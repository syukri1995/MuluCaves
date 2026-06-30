ssh -i ~/.ssh/mulu-key.pem -o StrictHostKeyChecking=no -o BatchMode=yes ec2-user@3.26.178.252 'sudo ls -la /opt/tomcat/webapps/ROOT/WEB-INF/classes/'
