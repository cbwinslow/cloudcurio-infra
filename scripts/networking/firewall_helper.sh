#!/bin/bash
# Firewall configuration helper for ensuring connectivity
set -e

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

echo "=============================================="
echo "Firewall Configuration Helper"
echo "=============================================="
echo ""

# Check if UFW is installed
if ! command -v ufw &> /dev/null; then
    echo "UFW not found. Installing..."
    sudo apt update
    sudo apt install -y ufw
fi

echo "Current UFW status:"
sudo ufw status verbose
echo ""

echo "Configuration options:"
echo "1) Enable basic firewall with essential services"
echo "2) Add ZeroTier ports"
echo "3) Add SSH port"
echo "4) Add Docker ports"
echo "5) Add monitoring ports (Prometheus, Grafana)"
echo "6) Add web server ports"
echo "7) Allow custom port"
echo "8) Remove rule"
echo "9) Show all rules"
echo "0) Exit"
echo ""

read -p "Choose an option [0-9]: " choice

case $choice in
    1)
        info "Enabling basic firewall..."
        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        sudo ufw allow 22/tcp comment 'SSH'
        sudo ufw --force enable
        success "Basic firewall enabled"
        ;;
    2)
        info "Adding ZeroTier ports..."
        sudo ufw allow 9993/udp comment 'ZeroTier'
        success "ZeroTier ports added"
        ;;
    3)
        read -p "SSH port (default 22): " ssh_port
        ssh_port=${ssh_port:-22}
        sudo ufw allow $ssh_port/tcp comment 'SSH'
        success "SSH port $ssh_port allowed"
        ;;
    4)
        info "Adding Docker ports..."
        sudo ufw allow 2375/tcp comment 'Docker API'
        sudo ufw allow 2376/tcp comment 'Docker API (TLS)'
        sudo ufw allow 2377/tcp comment 'Docker Swarm'
        sudo ufw allow 7946/tcp comment 'Docker Swarm'
        sudo ufw allow 7946/udp comment 'Docker Swarm'
        sudo ufw allow 4789/udp comment 'Docker Overlay'
        success "Docker ports added"
        ;;
    5)
        info "Adding monitoring ports..."
        sudo ufw allow 9090/tcp comment 'Prometheus'
        sudo ufw allow 3000/tcp comment 'Grafana'
        sudo ufw allow 9100/tcp comment 'Node Exporter'
        sudo ufw allow 3100/tcp comment 'Loki'
        success "Monitoring ports added"
        ;;
    6)
        info "Adding web server ports..."
        sudo ufw allow 80/tcp comment 'HTTP'
        sudo ufw allow 443/tcp comment 'HTTPS'
        sudo ufw allow 8080/tcp comment 'HTTP Alt'
        success "Web server ports added"
        ;;
    7)
        read -p "Port number: " port
        read -p "Protocol (tcp/udp): " proto
        read -p "Comment: " comment
        sudo ufw allow $port/$proto comment "$comment"
        success "Port $port/$proto allowed"
        ;;
    8)
        read -p "Rule number to delete: " rule_num
        sudo ufw delete $rule_num
        success "Rule deleted"
        ;;
    9)
        sudo ufw status numbered
        ;;
    0)
        echo "Exiting..."
        exit 0
        ;;
    *)
        error "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "Current firewall status:"
sudo ufw status verbose
echo ""
echo "Tips:"
echo "- Use 'sudo ufw status numbered' to see rule numbers"
echo "- Use 'sudo ufw delete <number>' to remove a rule"
echo "- Use 'sudo ufw disable' to disable firewall"
echo "- Use 'sudo ufw reload' to reload rules"
echo ""
