#!/bin/bash

# EC2 Instance Setup Script
# This script automates the setup of an EC2 instance and v2ray server

# Error handling
set -e
trap 'echo "Error: Script failed on line $LINENO"' ERR

# Check if running with sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root/sudo"
   exit 1
fi

# Update system packages
echo "Updating system packages..."
apt-get update && apt-get upgrade -y

# Install essential packages
echo "Installing essential packages..."
apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    nginx \
    certbot \
    python3-certbot-nginx \
    ufw

# Setup firewall
echo "Configuring firewall..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Install v2ray
echo "Installing v2ray..."
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

# Create v2ray config directory if it doesn't exist
mkdir -p /usr/local/etc/v2ray

# Generate UUID for v2ray
UUID=$(cat /proc/sys/kernel/random/uuid)

# Create v2ray config
cat > /usr/local/etc/v2ray/config.json << EOF
{
  "inbounds": [{
    "port": 443,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "${UUID}",
          "alterId": 0
        }
      ]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/v2ray"
      },
      "security": "tls",
      "tlsSettings": {
        "certificates": []
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF

# Start v2ray service
systemctl start v2ray
systemctl enable v2ray

# Print configuration info
echo "V2Ray Installation Complete!"
echo "Your UUID is: ${UUID}"
echo "Please configure your domain and SSL certificates"
