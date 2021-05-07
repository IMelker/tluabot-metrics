#!/bin/bash

VERSION="7.5.5"

# download grafana
mkdir grafana && cd grafana
apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_${VERSION}_amd64.deb
dpkg -i grafana_${VERSION}_amd64.deb
systemctl enable grafana-server
systemctl start grafana-server
systemctl status grafana-server

