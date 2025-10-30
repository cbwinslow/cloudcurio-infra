#!/bin/bash
# Network diagnostic and troubleshooting script
set -e

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

warning() {
    echo -e "${YELLOW}!${NC} $1"
}

info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

echo "=============================================="
echo "Network Diagnostics and Troubleshooting"
echo "=============================================="
echo ""

# Check internet connectivity
echo "=== Internet Connectivity ==="
if ping -c 3 8.8.8.8 &> /dev/null; then
    success "Internet connectivity: OK"
else
    error "Internet connectivity: FAILED"
fi

if ping -c 3 google.com &> /dev/null; then
    success "DNS resolution: OK"
else
    error "DNS resolution: FAILED"
fi
echo ""

# Display network interfaces
echo "=== Network Interfaces ==="
ip -brief addr show
echo ""

# Display routing table
echo "=== Routing Table ==="
ip route show
echo ""

# Display DNS configuration
echo "=== DNS Configuration ==="
if [ -f /etc/resolv.conf ]; then
    cat /etc/resolv.conf
fi
echo ""

# Check ZeroTier status
echo "=== ZeroTier Status ==="
if command -v zerotier-cli &> /dev/null; then
    success "ZeroTier is installed"
    
    echo "Node Info:"
    sudo zerotier-cli info
    
    echo ""
    echo "Network Status:"
    sudo zerotier-cli listnetworks
    
    echo ""
    echo "Peers:"
    sudo zerotier-cli listpeers | head -20
else
    warning "ZeroTier is not installed"
fi
echo ""

# Check firewall status
echo "=== Firewall Status ==="
if command -v ufw &> /dev/null; then
    info "UFW Status:"
    sudo ufw status verbose || true
fi

if command -v iptables &> /dev/null; then
    info "Active iptables rules:"
    sudo iptables -L -n | head -20
fi
echo ""

# Check listening ports
echo "=== Listening Ports ==="
info "Common service ports:"
sudo netstat -tuln | grep LISTEN | head -20 || ss -tuln | grep LISTEN | head -20
echo ""

# Test connectivity to common ports
echo "=== Port Connectivity Tests ==="
test_port() {
    local host=$1
    local port=$2
    local service=$3
    
    if timeout 2 bash -c "cat < /dev/null > /dev/tcp/$host/$port" 2>/dev/null; then
        success "$service ($host:$port) is reachable"
    else
        error "$service ($host:$port) is NOT reachable"
    fi
}

test_port "8.8.8.8" "53" "Google DNS"
test_port "1.1.1.1" "53" "Cloudflare DNS"
test_port "github.com" "443" "GitHub HTTPS"
test_port "google.com" "443" "Google HTTPS"
echo ""

# Check for common network issues
echo "=== Common Issues Check ==="

# Check MTU settings
echo "MTU Settings:"
ip link show | grep -i mtu

# Check for packet loss
echo ""
info "Testing for packet loss (to 8.8.8.8)..."
ping -c 10 -q 8.8.8.8 | tail -2

echo ""
echo "=============================================="
echo "Network Diagnostics Complete"
echo "=============================================="
echo ""
echo "If you're experiencing network issues:"
echo "1. Check if ZeroTier networks are joined: sudo zerotier-cli listnetworks"
echo "2. Verify firewall rules: sudo ufw status"
echo "3. Test connectivity to specific hosts: ping <host>"
echo "4. Check DNS resolution: nslookup <domain>"
echo "5. Review routing table: ip route show"
echo ""
