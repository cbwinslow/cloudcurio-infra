#!/bin/bash
# Installer script for ZeroTier
set -e

echo "Installing ZeroTier One..."

# Add ZeroTier GPG key
curl -s https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/zerotier-archive-keyring.gpg >/dev/null

# Add ZeroTier repository
echo "deb [signed-by=/usr/share/keyrings/zerotier-archive-keyring.gpg] https://download.zerotier.com/debian/$(lsb_release -sc) $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/zerotier.list

# Update and install
sudo apt update
sudo apt install -y zerotier-one

# Enable and start service
sudo systemctl enable zerotier-one
sudo systemctl start zerotier-one

echo "ZeroTier One installed successfully!"
echo "To join a network, run: sudo zerotier-cli join <network_id>"
echo "To get your node ID, run: sudo zerotier-cli info"
