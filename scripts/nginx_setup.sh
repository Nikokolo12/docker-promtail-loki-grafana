#!/bin/bash

# Setup Nginx
sudo apt-get -y update
sudo apt-get -y install nginx curl 

sudo systemctl start nginx
sudo systemctl enable nginx

sudo chmod 755 /var/www/html

sudo curl -o  /var/www/html/cat.jpg "https://as1.ftcdn.net/v2/jpg/02/36/99/22/1000_F_236992283_sNOxCVQeFLd5pdqaKGh8DRGMZy7P4XKm.jpg"
echo "<h2> Ready </h2>" | sudo tee /var/www/html/index.html
echo "<img src="cat.jpg" alt="Kitty">" | sudo tee -a /var/www/html/index.html

# Install Node Exporter
sudo useradd --no-create-home node_exporter

wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar xzf node_exporter-1.0.1.linux-amd64.tar.gz
sudo cp node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-1.0.1.linux-amd64.tar.gz node_exporter-1.0.1.linux-amd64

sudo cat << EOF >> /etc/systemd/system/node-exporter.service
[Unit]
Description=Prometheus Node Exporter Service
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node-exporter
sudo systemctl start node-exporter
sudo systemctl status node-exporter

# Install Promtail
curl -O -L "https://github.com/grafana/loki/releases/download/v2.4.1/promtail-linux-amd64.zip"
tar xzf "promtail-linux-amd64.zip"
sudo chmod a+x "promtail-linux-amd64"
sudo cp promtail-linux-amd64 /usr/local/bin/promtail
sudo mkdir -p /etc/promtail /etc/promtail/logs

sudo cat << EOF >> /etc/promtail/promtail-config.yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://54.237.238.93:3100/loki/api/v1/push

scrape_configs:
- job_name: system
  static_configs:
  - targets:
      - "localhost"
    labels:
      job: varlogs
      __path__: /var/log/*log
EOF

sudo cat << EOF >> /etc/systemd/system/promtail.service
[Unit] 
Description=Promtail service 
After=network.target 
 
[Service] 
Type=simple 
User=root 
ExecStart=/usr/local/bin/promtail -config.file /etc/promtail/promtail-config.yaml 
Restart=on-failure 
RestartSec=20 
StandardOutput=append:/etc/promtail/logs/promtail.log 
StandardError=append:/etc/promtail/logs/promtail.log 
 
[Install] 
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload 
sudo systemctl start promtail 
sudo systemctl status promtail 
sudo systemctl restart promtail 

sudo systemctl enable promtail.service
