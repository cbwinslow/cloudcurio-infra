#!/bin/bash
# Uninstaller script for Security Stack
set -e

echo "Uninstalling Security Stack..."

# Wazuh Agent
if command -v /var/ossec/bin/wazuh-control &> /dev/null; then
    echo "Uninstalling Wazuh Agent..."
    sudo /var/ossec/bin/wazuh-control stop || true
    sudo apt remove -y wazuh-agent || true
    sudo apt purge -y wazuh-agent || true
    sudo rm -rf /var/ossec
    sudo rm -f /etc/apt/sources.list.d/wazuh.list
    echo "Wazuh Agent uninstalled."
fi

# Suricata
if command -v suricata &> /dev/null; then
    echo "Uninstalling Suricata..."
    sudo systemctl stop suricata || true
    sudo systemctl disable suricata || true
    sudo apt remove -y suricata || true
    sudo apt purge -y suricata || true
    sudo rm -rf /etc/suricata
    sudo rm -rf /var/log/suricata
    echo "Suricata uninstalled."
fi

# fail2ban
if command -v fail2ban-client &> /dev/null; then
    echo "Uninstalling fail2ban..."
    sudo systemctl stop fail2ban || true
    sudo systemctl disable fail2ban || true
    sudo apt remove -y fail2ban || true
    sudo apt purge -y fail2ban || true
    sudo rm -rf /etc/fail2ban
    sudo rm -rf /var/log/fail2ban
    echo "fail2ban uninstalled."
fi

# ClamAV
if command -v clamscan &> /dev/null; then
    echo "Uninstalling ClamAV..."
    sudo systemctl stop clamav-freshclam || true
    sudo systemctl disable clamav-freshclam || true
    sudo apt remove -y clamav clamav-daemon || true
    sudo apt purge -y clamav clamav-daemon || true
    sudo rm -rf /var/lib/clamav
    echo "ClamAV uninstalled."
fi

# Update package cache
sudo apt update

# Clean up unused dependencies
sudo apt autoremove -y

echo "Security Stack uninstalled successfully!"
