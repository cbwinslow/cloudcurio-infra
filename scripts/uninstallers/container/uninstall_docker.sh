#!/bin/bash
# Uninstaller script for Docker and Docker Compose
set -e

# Security: Enable audit logging
AUDIT_LOG="/var/log/docker-uninstall.log"

audit_log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local user=${SUDO_USER:-$USER}
    echo "[$timestamp] USER=$user ACTION=$1 STATUS=$2 DETAILS=$3" >> "$AUDIT_LOG" 2>/dev/null || true
}

echo "=============================================="
echo "Docker and Docker Compose Uninstaller"
echo "=============================================="
echo ""

# Warning with detailed information
echo "⚠️  WARNING: This operation will:"
echo "   • Stop all running Docker containers"
echo "   • Remove all Docker containers"
echo "   • Remove all Docker images"
echo "   • Remove all Docker volumes (potential data loss)"
echo "   • Remove all Docker networks"
echo "   • Uninstall Docker completely"
echo ""
echo "This action cannot be undone!"
echo ""

# First confirmation
read -p "Do you want to see what will be removed before proceeding? (y/N): " show_details

if [ "$show_details" = "y" ] || [ "$show_details" = "Y" ]; then
    echo ""
    echo "=== Containers that will be removed ==="
    sudo docker ps -a 2>/dev/null || echo "No containers found"
    echo ""
    echo "=== Images that will be removed ==="
    sudo docker images 2>/dev/null || echo "No images found"
    echo ""
    echo "=== Volumes that will be removed ==="
    sudo docker volume ls 2>/dev/null || echo "No volumes found"
    echo ""
    echo "=== Networks that will be removed ==="
    sudo docker network ls 2>/dev/null || echo "No networks found"
    echo ""
fi

# Main confirmation
read -p "Type 'DELETE EVERYTHING' to confirm complete Docker removal: " confirm
if [ "$confirm" != "DELETE EVERYTHING" ]; then
    echo "Uninstallation cancelled."
    audit_log "DOCKER_UNINSTALL" "CANCELLED" "User cancelled operation"
    exit 0
fi

audit_log "DOCKER_UNINSTALL" "STARTED" "User confirmed complete removal"

# Stop all running containers
echo "Stopping all containers..."
if sudo docker ps -q 2>/dev/null | grep -q .; then
    sudo docker stop $(sudo docker ps -aq) 2>/dev/null || true
    audit_log "DOCKER_UNINSTALL" "INFO" "Stopped all containers"
else
    echo "No running containers to stop"
fi

# Remove all containers
echo "Removing all containers..."
if sudo docker ps -aq 2>/dev/null | grep -q .; then
    sudo docker rm $(sudo docker ps -aq) 2>/dev/null || true
    audit_log "DOCKER_UNINSTALL" "INFO" "Removed all containers"
else
    echo "No containers to remove"
fi

# Remove all images
echo "Removing all images..."
if sudo docker images -q 2>/dev/null | grep -q .; then
    sudo docker rmi $(sudo docker images -q) 2>/dev/null || true
    audit_log "DOCKER_UNINSTALL" "INFO" "Removed all images"
else
    echo "No images to remove"
fi

# Remove all volumes
echo "Removing all volumes..."
if sudo docker volume ls -q 2>/dev/null | grep -q .; then
    sudo docker volume rm $(sudo docker volume ls -q) 2>/dev/null || true
    audit_log "DOCKER_UNINSTALL" "INFO" "Removed all volumes"
else
    echo "No volumes to remove"
fi

# Remove all custom networks (preserve default networks)
echo "Removing custom networks..."
# Note: We remove networks by checking if they're not the default ones (bridge, host, none)
custom_networks=$(sudo docker network ls --format '{{.Name}}' | grep -v -E '^(bridge|host|none)$' || true)
if [ -n "$custom_networks" ]; then
    echo "$custom_networks" | xargs -r sudo docker network rm 2>/dev/null || true
    audit_log "DOCKER_UNINSTALL" "INFO" "Removed custom networks"
else
    echo "No custom networks to remove"
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

echo ""
echo "✓ Docker and Docker Compose uninstalled successfully!"
audit_log "DOCKER_UNINSTALL" "SUCCESS" "Complete removal finished"
echo ""
echo "Audit log saved to: $AUDIT_LOG"
