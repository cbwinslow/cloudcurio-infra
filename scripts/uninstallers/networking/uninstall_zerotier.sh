#!/bin/bash
# Uninstaller script for ZeroTier
set -e

echo "Uninstalling ZeroTier One..."

# Check if ZeroTier is installed
if ! command -v zerotier-cli &> /dev/null; then
    echo "ZeroTier is not installed. Nothing to uninstall."
    exit 0
fi

# Get list of joined networks
echo "Checking for joined networks..."
NETWORKS=$(zerotier-cli listnetworks -j 2>/dev/null | jq -r '.[].id' || echo "")

# Leave all networks
if [ -n "$NETWORKS" ]; then
    for network in $NETWORKS; do
        echo "Leaving network: $network"
        sudo zerotier-cli leave "$network" || true
    done
fi

# Stop and disable service
echo "Stopping ZeroTier service..."
sudo systemctl stop zerotier-one || true
sudo systemctl disable zerotier-one || true

# Remove package
echo "Removing ZeroTier package..."
sudo apt remove -y zerotier-one || true
sudo apt purge -y zerotier-one || true

# Remove repository configuration
echo "Removing ZeroTier repository..."
sudo rm -f /etc/apt/sources.list.d/zerotier.list
sudo rm -f /usr/share/keyrings/zerotier-archive-keyring.gpg

# Remove data directory
echo "Removing ZeroTier data..."
sudo rm -rf /var/lib/zerotier-one

# Update package cache
sudo apt update

echo "ZeroTier One uninstalled successfully!"
