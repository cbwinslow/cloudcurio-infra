#!/bin/bash
# Installer for additional networking tools
set -e

echo "Installing additional networking tools..."

# Update package cache
sudo apt update

# Install networking and diagnostic tools
echo "Installing network diagnostic tools..."
sudo apt install -y \
    traceroute \
    mtr \
    tcpdump \
    nmap \
    netcat-openbsd \
    dnsutils \
    net-tools \
    iproute2 \
    iperf3 \
    curl \
    wget \
    whois \
    telnet

# Install SSH and AutoSSH
echo "Installing SSH tools..."
sudo apt install -y \
    openssh-client \
    openssh-server \
    autossh

# Install proxy tools
echo "Installing proxy tools..."
sudo apt install -y \
    proxychains \
    tinyproxy \
    squid

# Configure SSH server
echo "Configuring SSH server..."
sudo systemctl enable ssh
sudo systemctl start ssh

# Install network monitoring tools
echo "Installing network monitoring tools..."
sudo apt install -y \
    vnstat \
    iftop \
    nethogs \
    bmon

echo ""
echo "Additional networking tools installed successfully!"
echo ""
echo "Installed tools:"
echo "  - Network diagnostics: traceroute, mtr, nmap, iperf3"
echo "  - Packet capture: tcpdump"
echo "  - SSH tools: openssh, autossh"
echo "  - Proxy tools: proxychains, tinyproxy, squid"
echo "  - Network monitoring: vnstat, iftop, nethogs, bmon"
echo ""
echo "Next steps:"
echo "  - Configure proxychains: sudo nano /etc/proxychains.conf"
echo "  - Configure tinyproxy: sudo nano /etc/tinyproxy/tinyproxy.conf"
echo "  - Start services: sudo systemctl start tinyproxy"
echo ""
