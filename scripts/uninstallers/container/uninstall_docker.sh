#!/bin/bash
# Uninstaller script for Docker and Docker Compose
set -e

echo "Uninstalling Docker and Docker Compose..."

# Warning
read -p "This will remove Docker and all containers, images, volumes, and networks. Continue? (y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Stop all running containers
echo "Stopping all containers..."
sudo docker stop $(sudo docker ps -aq) 2>/dev/null || true

# Remove all containers
echo "Removing all containers..."
sudo docker rm $(sudo docker ps -aq) 2>/dev/null || true

# Remove all images
echo "Removing all images..."
sudo docker rmi $(sudo docker images -q) 2>/dev/null || true

# Remove all volumes
echo "Removing all volumes..."
sudo docker volume rm $(sudo docker volume ls -q) 2>/dev/null || true

# Remove all networks
echo "Removing all networks..."
networks=$(sudo docker network ls -q)
if [ -n "$networks" ]; then
    sudo docker network rm $networks 2>/dev/null || true
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

echo "Docker and Docker Compose uninstalled successfully!"
