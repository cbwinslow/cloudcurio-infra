#!/bin/bash
# Uninstaller script for Docker and Docker Compose
set -e


fi

# Stop and disable service
echo "Stopping Docker service..."
sudo systemctl stop docker || true
sudo systemctl disable docker || true
sudo systemctl stop docker.socket || true
sudo systemctl disable docker.socket || true

# Remove Docker packages
echo "Removing Docker packages..."
sudo apt remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || true
sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || true

# Remove repository
echo "Removing Docker repository..."
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /usr/share/keyrings/docker-archive-keyring.gpg

# Remove Docker data
echo "Removing Docker data..."
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/docker

# Remove Docker group
echo "Removing Docker group..."
sudo groupdel docker 2>/dev/null || true

# Update package cache
sudo apt update

# Clean up unused dependencies
sudo apt autoremove -y


