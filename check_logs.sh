ssh -i ~/.ssh/mulu-key.pem -o StrictHostKeyChecking=no -o BatchMode=yes ec2-user@3.26.178.252 'sudo tail -n 50 /opt/tomcat/logs/catalina.out'
