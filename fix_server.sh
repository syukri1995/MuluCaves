ssh -i ~/.ssh/mulu-key.pem -o StrictHostKeyChecking=no -o BatchMode=yes ec2-user@3.26.178.252 'sudo mv /opt/tomcat/webapps/mulu-caves /opt/tomcat/webapps/ROOT; sudo systemctl restart tomcat; sudo bash -c "cat > /etc/nginx/conf.d/mulu.conf << EOF
server {
    listen 80;
    server_name mulucaves.live www.mulucaves.live 3.26.178.252;
    
    location / {
        proxy_pass http://localhost:8080/;
        proxy_set_header Host \\\System.Management.Automation.Internal.Host.InternalHost;
        proxy_set_header X-Real-IP \\\;
        proxy_set_header X-Forwarded-For \\\;
        proxy_set_header X-Forwarded-Proto \\\;
    }
}
EOF"; sudo systemctl restart nginx'
