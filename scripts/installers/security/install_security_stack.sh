#!/bin/bash
# Security Stack installer (Wazuh, Suricata)
set -e

echo "Security Stack Installer"
echo "======================="

# Install Suricata
echo "Installing Suricata IDS/IPS..."
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:oisf/suricata-stable
sudo apt-get update
sudo apt-get install -y suricata

# Update Suricata rules
echo "Updating Suricata rules..."
sudo suricata-update

# Enable and start Suricata
sudo systemctl enable suricata
sudo systemctl start suricata

echo "Suricata installed and running!"

# Ask about Wazuh
read -p "Install Wazuh agent? (y/n): " install_wazuh

if [ "$install_wazuh" = "y" ]; then
    echo "Installing Wazuh agent..."
    
    # Add Wazuh repository
    curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo gpg --dearmor -o /usr/share/keyrings/wazuh.gpg
    echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list
    
    sudo apt-get update
    sudo apt-get install -y wazuh-agent
    
    read -p "Enter Wazuh manager IP address: " manager_ip
    
    # Configure Wazuh agent
    sudo sed -i "s/<address>MANAGER_IP<\/address>/<address>$manager_ip<\/address>/" /var/ossec/etc/ossec.conf
    
    # Enable and start Wazuh
    sudo systemctl enable wazuh-agent
    sudo systemctl start wazuh-agent
    
    echo "Wazuh agent installed and configured!"
fi

# Install fail2ban
read -p "Install fail2ban? (y/n): " install_fail2ban

if [ "$install_fail2ban" = "y" ]; then
    echo "Installing fail2ban..."
    sudo apt-get install -y fail2ban
    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban
    echo "fail2ban installed!"
fi

# Install ClamAV
read -p "Install ClamAV antivirus? (y/n): " install_clamav

if [ "$install_clamav" = "y" ]; then
    echo "Installing ClamAV..."
    sudo apt-get install -y clamav clamav-daemon
    sudo systemctl stop clamav-freshclam
    sudo freshclam
    sudo systemctl start clamav-freshclam
    sudo systemctl enable clamav-freshclam
    echo "ClamAV installed!"
fi

echo "Security stack installation complete!"
echo "Suricata logs: /var/log/suricata/"
if [ "$install_wazuh" = "y" ]; then
    echo "Wazuh logs: /var/ossec/logs/"
fi
