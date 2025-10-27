#!/bin/bash
# SaltStack installer
set -e

echo "Installing SaltStack..."

# Add SaltStack repository
curl -fsSL https://repo.saltproject.io/salt/py3/ubuntu/$(lsb_release -rs)/amd64/SALT-PROJECT-GPG-PUBKEY-2023.pub | sudo gpg --dearmor -o /usr/share/keyrings/salt-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/$(lsb_release -rs)/amd64/latest $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/salt.list

# Update and install
sudo apt-get update

# Ask user what to install
echo "What would you like to install?"
echo "1) Salt Master"
echo "2) Salt Minion"
echo "3) Both"
read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        sudo apt-get install -y salt-master
        sudo systemctl enable salt-master
        sudo systemctl start salt-master
        echo "Salt Master installed!"
        ;;
    2)
        sudo apt-get install -y salt-minion
        read -p "Enter Salt Master IP/hostname: " master_ip
        echo "master: $master_ip" | sudo tee /etc/salt/minion.d/master.conf
        sudo systemctl enable salt-minion
        sudo systemctl start salt-minion
        echo "Salt Minion installed!"
        ;;
    3)
        sudo apt-get install -y salt-master salt-minion
        sudo systemctl enable salt-master salt-minion
        sudo systemctl start salt-master salt-minion
        echo "Salt Master and Minion installed!"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo "SaltStack installation complete!"
