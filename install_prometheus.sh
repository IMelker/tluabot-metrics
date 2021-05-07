#!/bin/bash

VERSION="2.18.1"

# download prometheus
mkdir prometheus && cd prometheus
wget https://github.com/prometheus/prometheus/releases/download/
v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz
tar zxvf prometheus-${VERSION}.linux-amd64.tar.gz
cd prometheus-${VERSION}.linux-amd64/

# create directories and copy files
mkdir /etc/prometheus
mkdir /var/lib/prometheus
cp prometheus promtool /usr/local/bin/
cp -r console_libraries consoles prometheus.yml /etc/prometheus

# add prometheus user
useradd --no-create-home --shell /bin/false prometheus

# own permitions
chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}

# install systemd
cp ./prometheus.service /etc/systemd/system/prometheus.service
systemctl daemon-reload
chown -R prometheus:prometheus /var/lib/prometheus
systemctl enable  prometheus.service
systemctl start prometheus.service
systemctl status  prometheus.service
