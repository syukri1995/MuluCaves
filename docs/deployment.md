# Deployment Guide

This document covers two deployment paths:

- **A. Local Docker** (zero-cost, fastest)
- **B. AWS EC2 via the AWS CLI** (free-tier eligible)

RDS is intentionally **not** used — keeping the demo deployable on a single
`t3.micro` instance avoids NAT/IGW gymnastics and keeps the bill at $0 during
the free-tier window.

---

## A. Local Docker (recommended for development)

See **`README.md` §2** for the one-liner. The `docker-compose.yml` orchestrates:

- `db` — MySQL 8 with the schema auto-loaded from `db/schema.sql`
- `app` — Tomcat 10.1 with the WAR mounted at deploy time

If you'd rather run containers manually:

```bash
# Database
docker run -d --name mulu-db \
  -e MYSQL_ROOT_PASSWORD=rootpw \
  -e MYSQL_DATABASE=tourism_db \
  -p 3306:3306 \
  -v "$(pwd)/db/schema.sql:/docker-entrypoint-initdb.d/01-schema.sql:ro" \
  mysql:8.0

# Build WAR
mvn -DskipTests package

# Tomcat
docker run -d --name mulu-app --link mulu-db:db -p 8080:8080 \
  -v "$(pwd)/target/mulu-caves.war:/usr/local/tomcat/webapps/mulu-caves.war:ro" \
  -e DB_URL=jdbc:mysql://db:3306/tourism_db?useSSL=false&serverTimezone=Asia/Kuala_Lumpur&allowPublicKeyRetrieval=true \
  -e DB_USERNAME=root -e DB_PASSWORD=rootpw \
  tomcat:10.1-jdk25
```

---

## B. AWS — EC2 via the AWS CLI

The bundled **`scripts/aws-deploy.sh`** walks you through this end-to-end.
This section explains what it does and how to clean up.

### B.1 What gets created

| Resource | Notes |
|---|---|
| EC2 `t3.micro` (or `t2.micro`) | Amazon Linux 2023, 20 GB gp3 root volume |
| Security group `mulu-caves-sg-<ts>` | Allows SSH (22) from your IP, HTTP (8080) from anywhere |
| IAM | None — uses whatever credentials `aws sts get-caller-identity` resolves |

### B.2 What gets installed

| Software | Source |
|---|---|
| Corretto JDK 25 | `dnf install java-25-amazon-corretto` |
| MariaDB 10.5 | `dnf install mariadb105-server` (MySQL-compatible wire protocol) |
| Tomcat 10.1.34 | Downloaded from `dlcdn.apache.org` |
| Schema | Loaded from `db/schema.sql` |

### B.3 Authentication

The script offers three options:

1. **Existing profile** (you've already run `aws configure`) — default.
2. **One-time prompt** — you'll be asked for Access Key ID and Secret.
3. **Environment variables** — `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`.

You will need `ec2:RunInstances`, `ec2:CreateSecurityGroup`,
`ec2:AuthorizeSecurityGroupIngress`, `ec2:DescribeInstances`,
`ssm:GetParameters`, and `iam:PassRole` is *not* required (we use the
default instance profile that AWS provides).

### B.4 Minimal IAM policy

If you create a dedicated user for this, here's the smallest policy that
makes the script work:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    { "Effect": "Allow", "Action": ["ec2:RunInstances", "ec2:DescribeInstances",
      "ec2:CreateSecurityGroup", "ec2:AuthorizeSecurityGroupIngress",
      "ec2:TerminateInstances", "ec2:DeleteSecurityGroup", "ec2:CreateTags"],
      "Resource": "*" },
    { "Effect": "Allow", "Action": "ssm:GetParameters",
      "Resource": "arn:aws:ssm:*:*:parameter/aws/service/ami-amazon-linux-latest/*" }
  ]
}
```

> Note: `Resource: "*"` is over-broad. Tighten with `arn:aws:ec2:region:account:*`
> in production. For coursework it's fine.

### B.5 Cost

| Resource | Free-tier eligible | Else |
|---|---|---|
| `t3.micro` Linux | 750 hrs/month for 12 months | ~$7.50/month |
| 20 GB gp3 EBS | 30 GB-month free | ~$1.60/month |
| Data transfer | 100 GB/month out | $0.09/GB |
| Public IPv4 | Always billed since Feb 2024 | ~$3.60/month |

**Always terminate the instance** when you're done with the demo.

### B.6 Cleanup

The script prints the exact commands at the end. They're also in the
README. To wipe everything:

```bash
aws ec2 terminate-instances --instance-ids <id> --region <region>
aws ec2 wait instance-terminated --instance-ids <id> --region <region>
aws ec2 delete-security-group --group-id <sg> --region <region>
```

### B.7 Redeploying after code changes

```bash
mvn -DskipTests package
scp -i ~/.ssh/<key>.pem target/mulu-caves.war ec2-user@<public-ip>:/tmp/
ssh -i ~/.ssh/<key>.pem ec2-user@<public-ip> \
  'sudo systemctl restart tomcat'
```

The systemd unit (`/etc/systemd/system/tomcat.service`) was created by the
bootstrap, so restarts are one command.

### B.8 Going beyond — production checklist

- [ ] **HTTPS** — put CloudFront/ALB in front and terminate TLS with ACM.
- [ ] **RDS** — move the DB off the instance for durability + automated backups.
- [ ] **Secrets Manager** — replace `db.properties` plaintext with secrets.
- [ ] **IMDSv2** — `ec2 modify-instance-metadata-options --http-tokens required`.
- [ ] **Restrict port 8080** to the ALB SG, not `0.0.0.0/0`.
- [ ] **Rotate the admin password** — log in and run a SQL update with a new BCrypt hash.
- [ ] **CloudWatch alarms** — CPU, disk, HTTP 5xx.

For CSC584 submission purposes, **none of the above are required**. The
script's output (a public URL + the assignment demo) is sufficient.