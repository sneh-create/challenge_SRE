#!/bin/bash

# Variables
GRAFANA_PORT=3000
JENKINS_PORT=8080
DOMAIN_GRAFANA="grafana.local"
DOMAIN_JENKINS="jenkins.local"
SSL_CERT_PATH="/etc/ssl/certs/nginx-selfsigned.crt"
SSL_KEY_PATH="/etc/ssl/private/nginx-selfsigned.key"
HTPASSWD_FILE="/etc/nginx/.htpasswd"
DOCKER_COMPOSE_FILE="docker-compose.yml"
NGINX_CONF="/etc/nginx/sites-available/grafana-jenkins"
ALLOWED_IP="203.0.113.0/24"  # Replace with your IP range for access control
RATE_LIMIT_ZONE_NAME="jenkins_limit"
RATE_LIMIT_RATE="10r/s"
RATE_LIMIT_BURST=20

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use sudo."
   exit 1
fi

# Step 1: Install required packages
echo "Installing required packages..."
apt update
apt install -y docker docker-compose nginx apache2-utils openssl

# Step 2: Set up Docker Compose for Grafana and Jenkins
echo "Setting up Docker Compose for Grafana and Jenkins..."
cat <<EOF > $DOCKER_COMPOSE_FILE
version: '3.8'
services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "$GRAFANA_PORT:$GRAFANA_PORT"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin

  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    ports:
      - "$JENKINS_PORT:$JENKINS_PORT"
    volumes:
      - jenkins_home:/var/jenkins_home

volumes:
  jenkins_home:
EOF

docker-compose up -d

# Step 3: Create self-signed SSL certificate
echo "Creating self-signed SSL certificate..."
mkdir -p /etc/ssl/private
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout $SSL_KEY_PATH \
  -out $SSL_CERT_PATH \
  -subj "/CN=localhost"

# Step 4: Configure Basic Authentication for Jenkins
echo "Setting up Basic Authentication for Jenkins..."
htpasswd -cb $HTPASSWD_FILE admin admin123  # Replace 'admin123' with your desired password

# Step 5: Configure Nginx
echo "Configuring Nginx..."
cat <<EOF > $NGINX_CONF
# Grafana
server {
    listen 443 ssl;
    server_name $DOMAIN_GRAFANA;

    ssl_certificate $SSL_CERT_PATH;
    ssl_certificate_key $SSL_KEY_PATH;

    location / {
        proxy_pass http://localhost:$GRAFANA_PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

# Jenkins
server {
    listen 443 ssl;
    server_name $DOMAIN_JENKINS;

    ssl_certificate $SSL_CERT_PATH;
    ssl_certificate_key $SSL_KEY_PATH;

    # Restrict access by IP
    location / {
        auth_basic "Restricted Access";
        auth_basic_user_file $HTPASSWD_FILE;

        allow $ALLOWED_IP;
        deny all;

        # Rate limiting
        limit_req zone=$RATE_LIMIT_ZONE_NAME burst=$RATE_LIMIT_BURST nodelay;

        proxy_pass http://localhost:$JENKINS_PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name $DOMAIN_GRAFANA $DOMAIN_JENKINS;
    return 301 https://\$host\$request_uri;
}
EOF

# Enable site and test Nginx configuration
ln -s $NGINX_CONF /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx

# Step 6: Add domains to /etc/hosts
echo "Adding domains to /etc/hosts..."
cat <<EOF >> /etc/hosts
127.0.0.1 $DOMAIN_GRAFANA
127.0.0.1 $DOMAIN_JENKINS
EOF

# Step 7: Configure Nginx rate limiting
echo "Configuring rate limiting..."
cat <<EOF >> /etc/nginx/nginx.conf

# Rate limit zone for Jenkins
limit_req_zone \$binary_remote_addr zone=$RATE_LIMIT_ZONE_NAME:10m rate=$RATE_LIMIT_RATE;
EOF

# Reload Nginx
nginx -t
systemctl reload nginx

# Step 8: Validate setup
echo "Validation:"
echo "- Access Grafana: https://$DOMAIN_GRAFANA"
echo "- Access Jenkins: https://$DOMAIN_JENKINS (username: admin, password: admin123)"

echo "Setup completed successfully!"
