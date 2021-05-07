#!/bin/bash

VERSION="1.1.2"
PROMETHEUS_YML="/etc/prometheus/prometheus.yml"

# download prometheus
mkdir node_exporter && cd node_exporter
 https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz
tar xvfz node_exporter-*.*-amd64.tar.gz
cd node_exporter-*.*-amd64

# copy files and give rights
mkdir -p /etc/prometheus/node-exporter/
cp * /etc/prometheus/node-exporter/
chown -R prometheus:prometheus /etc/prometheus/node-exporter/

cp ./node-exporter.service /etc/systemd/system/node-exporter.service

# add 
echo "scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090', 'localhost:9100']" >> PROMETHEUS_YML

systemctl daemon-reload
systemctl enable node-exporter.service
systemctl start node-exporter.service
systemctl status node-exporter.service

# reload prometheus
systemctl restart prometheus.service
systemctl status prometheus.service