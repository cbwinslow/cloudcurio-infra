#!/bin/bash
# Uninstaller script for Monitoring Stack (Prometheus, Grafana, Loki)
set -e

echo "Uninstalling Monitoring Stack..."

# Prometheus
if systemctl list-units --full -all | grep -q prometheus.service; then
    echo "Uninstalling Prometheus..."
    sudo systemctl stop prometheus || true
    sudo systemctl disable prometheus || true
    sudo rm -f /etc/systemd/system/prometheus.service
    sudo rm -f /usr/local/bin/prometheus
    sudo rm -f /usr/local/bin/promtool
    sudo rm -rf /etc/prometheus
    sudo rm -rf /var/lib/prometheus
    sudo userdel prometheus 2>/dev/null || true
    echo "Prometheus uninstalled."
fi

# Grafana
if command -v grafana-server &> /dev/null; then
    echo "Uninstalling Grafana..."
    sudo systemctl stop grafana-server || true
    sudo systemctl disable grafana-server || true
    sudo apt remove -y grafana || true
    sudo apt purge -y grafana || true
    sudo rm -rf /etc/grafana
    sudo rm -rf /var/lib/grafana
    sudo rm -rf /var/log/grafana
    sudo rm -f /etc/apt/sources.list.d/grafana.list
    echo "Grafana uninstalled."
fi

# Loki
if systemctl list-units --full -all | grep -q loki.service; then
    echo "Uninstalling Loki..."
    sudo systemctl stop loki || true
    sudo systemctl disable loki || true
    sudo rm -f /etc/systemd/system/loki.service
    sudo rm -f /usr/local/bin/loki
    sudo rm -rf /etc/loki
    sudo rm -rf /var/lib/loki
    sudo userdel loki 2>/dev/null || true
    echo "Loki uninstalled."
fi

# Promtail
if systemctl list-units --full -all | grep -q promtail.service; then
    echo "Uninstalling Promtail..."
    sudo systemctl stop promtail || true
    sudo systemctl disable promtail || true
    sudo rm -f /etc/systemd/system/promtail.service
    sudo rm -f /usr/local/bin/promtail
    sudo rm -rf /etc/promtail
    sudo userdel promtail 2>/dev/null || true
    echo "Promtail uninstalled."
fi

# Node Exporter
if systemctl list-units --full -all | grep -q node_exporter.service; then
    echo "Uninstalling Node Exporter..."
    sudo systemctl stop node_exporter || true
    sudo systemctl disable node_exporter || true
    sudo rm -f /etc/systemd/system/node_exporter.service
    sudo rm -f /usr/local/bin/node_exporter
    sudo userdel node_exporter 2>/dev/null || true
    echo "Node Exporter uninstalled."
fi

# Reload systemd
sudo systemctl daemon-reload

# Update package cache
sudo apt update

echo "Monitoring Stack uninstalled successfully!"
