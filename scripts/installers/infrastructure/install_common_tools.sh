#!/bin/bash
# Infrastructure tools installer (Teleport, Chezmoi, common tools)
set -e

echo "Infrastructure Tools Installer"
echo "============================="

# Install Chezmoi
echo "Installing Chezmoi..."
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
echo "Chezmoi installed! Initialize with: chezmoi init"

# Install common system tools
echo "Installing common system utilities..."
sudo apt-get update
sudo apt-get install -y \
    htop \
    tmux \
    vim \
    git \
    curl \
    wget \
    jq \
    unzip \
    net-tools \
    dnsutils \
    traceroute \
    tcpdump \
    iftop \
    iotop \
    ncdu \
    tree \
    rsync \
    screen

echo "Common tools installed!"

# Ask about Teleport
read -p "Install Teleport? (y/n): " install_teleport

if [ "$install_teleport" = "y" ]; then
    echo "Installing Teleport..."
    TELEPORT_VERSION="13.0.0"
    cd /tmp
    wget "https://get.gravitational.com/teleport_${TELEPORT_VERSION}_amd64.deb"
    sudo dpkg -i "teleport_${TELEPORT_VERSION}_amd64.deb"
    echo "Teleport installed! Configure at /etc/teleport/teleport.yaml"
fi

# Install systemd-journal
echo "Configuring systemd journal..."
sudo mkdir -p /var/log/journal
sudo systemd-tmpfiles --create --prefix /var/log/journal
sudo systemctl restart systemd-journald

# Install and configure chrony for time sync
echo "Installing chrony for time synchronization..."
sudo apt-get install -y chrony
sudo systemctl enable chrony
sudo systemctl start chrony

# Install lsof and strace for debugging
echo "Installing debugging tools..."
sudo apt-get install -y lsof strace ltrace

# Install network tools
echo "Installing additional network tools..."
sudo apt-get install -y \
    nmap \
    netcat \
    socat \
    mtr \
    whois \
    iproute2

echo "Infrastructure tools installation complete!"
echo ""
echo "Installed tools:"
echo "- Chezmoi (dotfile manager)"
echo "- System monitoring: htop, iotop, iftop"
echo "- Network tools: nmap, netcat, mtr, tcpdump"
echo "- Time sync: chrony"
echo "- Debugging: lsof, strace, ltrace"
if [ "$install_teleport" = "y" ]; then
    echo "- Teleport (access management)"
fi
