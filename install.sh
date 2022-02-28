#!/usr/bin/env bash

echo "Installing Node Exporter on Linux/Ubuntu"
echo "Make sure to get the latest version info from https://github.com/prometheus/node_exporter/releases"
export VER='1.3.1'

useradd -M -r -s /bin/false node_exporter
id node_exporter
yum -y install wget
wget https://github.com/prometheus/node_exporter/releases/download/v${VER}/node_exporter-${VER}.linux-amd64.tar.gz
tar xzf node_exporter-${VER}.linux-amd64.tar.gz
cp node_exporter-${VER}.linux-amd64/node_exporter /usr/local/bin/
chown node_exporter:node_exporter /usr/local/bin/node_exporter

cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start node_exporter.service
systemctl enable node_exporter.service
systemctl status node_exporter.service

netstat -tupln | grep 9100

echo "If applicable allow the port for external access"
echo "ufw allow from x.x.x.x/32 to any port 9100"
