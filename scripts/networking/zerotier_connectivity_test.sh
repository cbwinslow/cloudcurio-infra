#!/bin/bash
# Network connectivity tester for ZeroTier mesh networks
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
echo "ZeroTier Mesh Network Connectivity Tester"
echo "=============================================="
echo ""

# Check if ZeroTier is installed
if ! command -v zerotier-cli &> /dev/null; then
    error "ZeroTier is not installed!"
    echo "Install it with: bash scripts/installers/networking/install_zerotier.sh"
    exit 1
fi

# Get ZeroTier status
echo "=== ZeroTier Node Information ==="
sudo zerotier-cli info
echo ""

# List networks
echo "=== Joined Networks ==="
networks=$(sudo zerotier-cli listnetworks -j)
echo "$networks" | jq -r '.[] | "Network: \(.id) | Name: \(.name) | Status: \(.status)"'
echo ""

# Check if any networks are joined
network_count=$(echo "$networks" | jq '. | length')
if [ "$network_count" -eq 0 ]; then
    error "No networks joined!"
    echo "Join a network with: sudo zerotier-cli join <network_id>"
    exit 1
fi

# Test connectivity to ZeroTier nodes
echo "=== Testing Connectivity to Mesh Peers ==="

# Define common ZeroTier IP ranges to test
# These should be customized based on your network configuration
TEST_IPS=(
    "172.28.0.1"
    "172.28.0.10"
    "172.28.0.20"
    "172.28.0.100"
)

# Allow user to provide custom IPs
if [ $# -gt 0 ]; then
    TEST_IPS=("$@")
    info "Testing custom IP addresses: ${TEST_IPS[*]}"
fi

reachable=0
unreachable=0

for ip in "${TEST_IPS[@]}"; do
    if ping -c 2 -W 2 "$ip" &> /dev/null; then
        success "Can reach $ip"
        reachable=$((reachable + 1))
    else
        error "Cannot reach $ip"
        unreachable=$((unreachable + 1))
    fi
done

echo ""
echo "=== Connectivity Summary ==="
echo "Reachable nodes: $reachable"
echo "Unreachable nodes: $unreachable"
echo ""

# Test DNS resolution over ZeroTier
echo "=== Testing DNS Resolution ==="
if nslookup google.com &> /dev/null; then
    success "DNS resolution working"
else
    error "DNS resolution failing"
fi
echo ""

# List ZeroTier peers
echo "=== ZeroTier Peers ==="
sudo zerotier-cli listpeers | head -10
echo ""

# Show ZeroTier interface info
echo "=== ZeroTier Network Interfaces ==="
ip addr show | grep -A 5 "zt" || echo "No ZeroTier interfaces found"
echo ""

# Check ZeroTier service status
echo "=== ZeroTier Service Status ==="
if systemctl is-active --quiet zerotier-one; then
    success "ZeroTier service is running"
else
    error "ZeroTier service is not running"
    echo "Start it with: sudo systemctl start zerotier-one"
fi
echo ""

echo "=============================================="
echo "Testing Complete"
echo "=============================================="
echo ""
echo "If you're having connectivity issues:"
echo "1. Verify network is authorized in ZeroTier Central"
echo "2. Check if nodes are online: sudo zerotier-cli listpeers"
echo "3. Verify firewall allows UDP 9993"
echo "4. Check network routes: ip route"
echo "5. Review ZeroTier logs: sudo journalctl -u zerotier-one -n 50"
echo ""
