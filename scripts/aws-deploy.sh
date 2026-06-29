#!/usr/bin/env bash
# ==========================================================
# AWS deployment — uses the AWS CLI; no hardcoded keys.
# Prompts you for AWS_ACCESS_KEY_ID + AWS_SECRET_ACCESS_KEY
# (or uses an existing `aws configure` profile), then:
#
#   1. Provisions a t3.micro EC2 instance with Amazon Linux 2023
#   2. Installs Corretto 21, Tomcat 10, and MariaDB (MySQL-compatible)
#   3. Imports the schema and seeds the database
#   4. Deploys the WAR
#   5. Opens port 8080
#
# After this runs you will have a public URL like
#   http://<ec2-public-ip>:8080/mulu-caves
#
# Estimated cost: free-tier eligible for 12 months if you stay within
# 750 hrs/month of t2.micro/t3.micro. Otherwise ~$8/month.
# ==========================================================
set -euo pipefail

# ---------- 1. AWS authentication ----------
echo "==> AWS authentication"
echo "    Choose how to provide credentials:"
echo "      [1] Use an existing profile (you've already run 'aws configure')"
echo "      [2] Enter Access Key ID + Secret now (prompted)"
echo "      [3] Use environment variables AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY"
read -r -p "    Pick [1/2/3] (default 1): " auth_choice
auth_choice="${auth_choice:-1}"

case "$auth_choice" in
    1)
        if ! aws sts get-caller-identity > /dev/null 2>&1; then
            echo "!! 'aws configure' hasn't been run, or the default profile is invalid." >&2
            echo "   Run: aws configure --profile <name>    then re-run this script with AWS_PROFILE=<name>." >&2
            exit 1
        fi
        echo "    Using AWS profile: ${AWS_PROFILE:-default}"
        ;;
    2)
        read -r -p "    AWS_ACCESS_KEY_ID: " AWS_ACCESS_KEY_ID
        read -r -s -p "    AWS_SECRET_ACCESS_KEY: " AWS_SECRET_ACCESS_KEY
        echo
        export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
        if ! aws sts get-caller-identity > /dev/null 2>&1; then
            echo "!! Credentials rejected by AWS." >&2
            exit 1
        fi
        ;;
    3)
        if [[ -z "${AWS_ACCESS_KEY_ID:-}" || -z "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
            echo "!! AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY must be set in your shell." >&2
            exit 1
        fi
        echo "    Using shell environment credentials."
        ;;
    *)
        echo "!! Invalid choice." >&2
        exit 1
        ;;
esac

# ---------- 2. Region + key pair ----------
read -r -p "==> AWS region [ap-southeast-1]: " AWS_REGION
AWS_REGION="${AWS_REGION:-ap-southeast-1}"
AWS_REGION="${AWS_REGION//$'\r'/}"
export AWS_DEFAULT_REGION="$AWS_REGION"

read -r -p "==> EC2 key pair name (must exist in this region): " KEY_NAME
KEY_NAME="${KEY_NAME//$'\r'/}"
read -r -p "==> EC2 instance type [t3.micro]: " INSTANCE_TYPE
INSTANCE_TYPE="${INSTANCE_TYPE:-t3.micro}"
INSTANCE_TYPE="${INSTANCE_TYPE//$'\r'/}"

# Allow SSH from the operator's public IP only — safer than 0.0.0.0/0.
read -r -p "==> Restrict SSH to your current public IP? [Y/n]: " restrict_ip
restrict_ip="${restrict_ip:-Y}"
restrict_ip="${restrict_ip//$'\r'/}"
if [[ "$restrict_ip" =~ ^[Yy]$ ]]; then
    MY_IP="$(curl -s https://checkip.amazonaws.com)/32"
    echo "    Detected public IP: $MY_IP"
else
    MY_IP="0.0.0.0/0"
fi

# ---------- 3. Build the WAR ----------
echo "==> Building WAR (mvn package)..."
(cd "$(dirname "$0")/.." && mvn -q -DskipTests clean package)
WAR_PATH="$(cd "$(dirname "$0")/.." && pwd)/target/mulu-caves.war"
if [[ ! -f "$WAR_PATH" ]]; then
    echo "!! WAR not found at $WAR_PATH" >&2
    exit 1
fi

# ---------- 4. Security group ----------
SG_NAME="mulu-caves-sg-$(date +%s)"
echo "==> Creating security group: $SG_NAME"
SG_ID="$(aws ec2 create-security-group \
    --group-name "$SG_NAME" \
    --description "Mulu Caves tourism app (HTTP 8080 + SSH 22)" \
    --query 'GroupId' --output text)"

aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --protocol tcp --port 22 --cidr "$MY_IP" > /dev/null
aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --protocol tcp --port 8080 --cidr 0.0.0.0/0 > /dev/null

# ---------- 5. EC2 instance ----------
AMI_ID="ami-0b17abf1c9f45c7b9"

echo "==> Launching $INSTANCE_TYPE in $AWS_REGION (AMI: $AMI_ID)"
INSTANCE_ID="$(MSYS_NO_PATHCONV=1 aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SG_ID" \
    --region "$AWS_REGION" \
    --block-device-mappings 'DeviceName=/dev/xvda,Ebs={VolumeSize=20,VolumeType=gp3}' \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=mulu-caves},{Key=Project,Value=CSC584}]" \
    --query 'Instances[0].InstanceId' --output text)"
echo "    Instance: $INSTANCE_ID"

echo "==> Waiting for instance to be running..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID" --region "$AWS_REGION"

PUBLIC_IP="$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" --region "$AWS_REGION" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)"
PUBLIC_DNS="$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" --region "$AWS_REGION" \
    --query 'Reservations[0].Instances[0].PublicDnsName' --output text)"

echo "    Public IP : $PUBLIC_IP"
echo "    Public DNS: $PUBLIC_DNS"

echo "==> Waiting 20 seconds for SSH to boot up..."
sleep 20

# ---------- 6. Upload WAR + bootstrap ----------
SSH_OPTS=(-i "${HOME}/.ssh/${KEY_NAME}.pem" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null)
SCP_OPTS=(-i "${HOME}/.ssh/${KEY_NAME}.pem" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null)

echo "==> Uploading WAR + schema..."
scp "${SCP_OPTS[@]}" "$WAR_PATH"               "ec2-user@${PUBLIC_IP}:/tmp/mulu-caves.war"
scp "${SCP_OPTS[@]}" "$(dirname "$0")/../db/schema.sql" "ec2-user@${PUBLIC_IP}:/tmp/schema.sql"

# ---------- 7. Bootstrap script ----------
read -r -s -p "==> MySQL root password for the EC2 instance (will be set + used): " DB_PASSWORD
DB_PASSWORD="${DB_PASSWORD//$'\r'/}"
echo
read -r -s -p "==> Confirm password: " DB_PASSWORD_2
DB_PASSWORD_2="${DB_PASSWORD_2//$'\r'/}"
echo
[[ "$DB_PASSWORD" == "$DB_PASSWORD_2" ]] || { echo "!! Passwords do not match." >&2; exit 1; }

BOOTSTRAP=$(cat <<EOF
set -euo pipefail
sudo dnf -y install java-25-amazon-corretto mariadb105-server
sudo systemctl enable --now mariadb
sudo mysql -e "CREATE DATABASE IF NOT EXISTS tourism_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql tourism_db < /tmp/schema.sql
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASSWORD}'; FLUSH PRIVILEGES;"

sudo dnf -y install wget
sudo mkdir -p /opt/tomcat
cd /tmp
sudo wget -q https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.34/bin/apache-tomcat-10.1.34.tar.gz
sudo tar -xzf apache-tomcat-10.1.34.tar.gz -C /opt/tomcat --strip-components=1
sudo useradd -r -d /opt/tomcat -s /sbin/nologin tomcat || true
sudo chown -R tomcat:tomcat /opt/tomcat

#echo "Deploying application..."
sudo rm -rf /opt/tomcat/webapps/mulu-caves /opt/tomcat/webapps/mulu-caves.war
sudo mkdir -p /opt/tomcat/webapps/mulu-caves
cd /opt/tomcat/webapps/mulu-caves
sudo /usr/lib/jvm/java-25-amazon-corretto.x86_64/bin/jar xf /tmp/mulu-caves.war

sudo mkdir -p /opt/tomcat/webapps/mulu-caves/WEB-INF/classes
sudo bash -c "cat > /opt/tomcat/webapps/mulu-caves/WEB-INF/classes/db.properties << 'EOFPROP'
jdbc.url=jdbc:mysql://localhost:3306/tourism_db?useSSL=false&serverTimezone=Asia/Kuala_Lumpur&allowPublicKeyRetrieval=true
db.username=root
db.password=${DB_PASSWORD}
db.pool.maximum=10
db.pool.minimum=2
db.pool.timeout=30000
EOFPROP"

sudo chown -R tomcat:tomcat /opt/tomcat/webapps/mulu-caves
sudo chown tomcat:tomcat /opt/tomcat/webapps/mulu-caves/WEB-INF/classes/db.properties

# systemd unit
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<'UNIT'
[Unit]
Description=Apache Tomcat 10
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
UNIT

sudo systemctl daemon-reload
sudo systemctl enable --now tomcat
EOF
)

echo "==> Running bootstrap on the instance (this can take 3-5 minutes)..."
ssh "${SSH_OPTS[@]}" "ec2-user@${PUBLIC_IP}" "bash -s" <<< "$BOOTSTRAP"

# ---------- 8. Health check ----------
echo "==> Waiting for app to come online..."
for i in $(seq 1 30); do
    if curl -fsS "http://${PUBLIC_IP}:8080/mulu-caves/home" > /dev/null 2>&1; then
        break
    fi
    sleep 5
done

cat <<OUT

============================================================
🎉 Deployment complete.

   Public site : http://${PUBLIC_IP}:8080/mulu-caves/home
   Admin login : http://${PUBLIC_IP}:8080/mulu-caves/admin/login
   SSH         : ssh ${SSH_OPTS[@]/#-i /-i } ec2-user@${PUBLIC_IP}

   Default admin credentials: admin / admin123
   (Change them in production — see docs/deployment.md)

   To redeploy after code changes:
     mvn -DskipTests package
     scp ${SCP_OPTS[@]} target/mulu-caves.war ec2-user@${PUBLIC_IP}:/tmp/
     ssh ${SSH_OPTS[@]} ec2-user@${PUBLIC_IP} 'sudo systemctl restart tomcat'

   Don't forget to TERMINATE the instance when done:
     aws ec2 terminate-instances --instance-ids ${INSTANCE_ID} --region ${AWS_REGION}
     aws ec2 delete-security-group   --group-id ${SG_ID} --region ${AWS_REGION}
============================================================
OUT