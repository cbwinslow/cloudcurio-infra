#!/bin/bash
# Comprehensive monitoring stack installer
set -e

echo "Installing Monitoring Stack (Prometheus, Grafana, Loki)..."

# Install Prometheus
echo "Installing Prometheus..."
PROM_VERSION="2.45.0"
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz
sudo mv prometheus-${PROM_VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-${PROM_VERSION}.linux-amd64/promtool /usr/local/bin/
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo useradd --no-create-home --shell /bin/false prometheus || true

# Install Grafana
echo "Installing Grafana..."
sudo apt-get install -y software-properties-common
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/grafana-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/grafana-archive-keyring.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Install Loki
echo "Installing Loki..."
LOKI_VERSION="2.9.0"
cd /tmp
wget https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip
unzip loki-linux-amd64.zip
sudo mv loki-linux-amd64 /usr/local/bin/loki
sudo mkdir -p /etc/loki /var/lib/loki
sudo useradd --no-create-home --shell /bin/false loki || true

echo "Monitoring stack installed successfully!"
echo "Grafana is available at http://localhost:3000 (default credentials: admin/admin)"
echo "Prometheus will be at http://localhost:9090"
echo "Loki will be at http://localhost:3100"
