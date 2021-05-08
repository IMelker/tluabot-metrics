#!/bin/bash

PROMETHEUS_YML="/etc/prometheus/prometheus.yml"

# download prometheus
mkdir json_exporter && cd json_exporter

# download json_exporter
git clone https://github.com/prometheus-community/json_exporter.git
cd ./json_exporter
make build

# copy files and give rights
mkdir -p /etc/prometheus/json-exporter/
cp ./json_exporter /etc/prometheus/json-exporter/json_exporter
cp ./examples/config.yml /etc/prometheus/json-exporter/config.yml
chown -R prometheus:prometheus /etc/prometheus/json-exporter/

cp ./json-exporter.service /etc/systemd/system/json-exporter.service

# add 
echo \
"- job_name: json_exporter
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:7979']
- job_name: json
  metrics_path: /probe
  static_configs:
    - targets:
      - http://host-1.foobar.com/dummy/data.json
      - http://host-2:8000/other-examples/data.json
      - http://localhost:8000/examples/data.json
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
    - source_labels: [__param_target]
      target_label: instance
    - target_label: __address__
      replacement: localhost:7979" >> PROMETHEUS_YML

systemctl daemon-reload
systemctl enable json-exporter.service
systemctl start json-exporter.service
systemctl status json-exporter.service

# reload prometheus
systemctl restart prometheus.service
systemctl status prometheus.service