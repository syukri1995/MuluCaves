ssh -i ~/.ssh/mulu-key.pem -o StrictHostKeyChecking=no -o BatchMode=yes ec2-user@3.26.178.252 'sudo mkdir -p /opt/tomcat/webapps/ROOT; sudo unzip -q /tmp/mulu-caves.war -d /opt/tomcat/webapps/ROOT; sudo mkdir -p /opt/tomcat/webapps/ROOT/WEB-INF/classes; sudo bash -c "cat > /opt/tomcat/webapps/ROOT/WEB-INF/classes/db.properties << EOFPROP
jdbc.url=jdbc:mysql://localhost:3306/tourism_db?useSSL=false&serverTimezone=Asia/Kuala_Lumpur&allowPublicKeyRetrieval=true
db.username=root
db.password=mulu2026
db.pool.maximum=10
db.pool.minimum=2
db.pool.timeout=30000
EOFPROP"; sudo chown -R tomcat:tomcat /opt/tomcat/webapps/ROOT; sudo systemctl restart tomcat'
