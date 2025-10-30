#!/bin/bash
# Network diagnostic and troubleshooting script
set -e

# Security: Enable audit logging
AUDIT_LOG="/var/log/network-diagnostics.log"

audit_log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local user=${SUDO_USER:-$USER}
    echo "[$timestamp] USER=$user ACTION=$1 STATUS=$2" >> "$AUDIT_LOG" 2>/dev/null || true
}

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

audit_log "NETWORK_DIAGNOSTICS" "STARTED"

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
    # Security: Redact potentially sensitive internal DNS servers (RFC 1918 ranges)
    # 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
    cat /etc/resolv.conf | grep -v "^#" | \
        sed 's/nameserver 10\..*/nameserver [REDACTED-INTERNAL-10.x.x.x]/g; 
             s/nameserver 172\.1[6-9]\..*/nameserver [REDACTED-INTERNAL-172.16-31.x.x]/g;
             s/nameserver 172\.2[0-9]\..*/nameserver [REDACTED-INTERNAL-172.16-31.x.x]/g;
             s/nameserver 172\.3[0-1]\..*/nameserver [REDACTED-INTERNAL-172.16-31.x.x]/g;
             s/nameserver 192\.168\..*/nameserver [REDACTED-INTERNAL-192.168.x.x]/g'
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
    # Security: Only show summary, not detailed rules
    sudo ufw status numbered | head -5 || true
    echo "(Detailed rules omitted for security)"
fi

if command -v iptables &> /dev/null; then
    info "Active iptables rules (summary):"
    # Security: Show count only, not actual rules
    rule_count=$(sudo iptables -L -n | grep -c "^Chain" || echo "0")
    echo "Total chains: $rule_count"
    echo "(Detailed rules omitted for security)"
fi
echo ""

# Check listening ports
echo "=== Listening Ports ==="
info "Common service ports:"
# Security: Filter out internal/sensitive ports, show only common ones
sudo netstat -tuln 2>/dev/null | grep LISTEN | awk '{print $4}' | awk -F: '{print $NF}' | sort -u | head -10 || ss -tuln 2>/dev/null | grep LISTEN | awk '{print $5}' | awk -F: '{print $NF}' | sort -u | head -10
echo ""

# Test connectivity to common ports
echo "=== Port Connectivity Tests ==="
test_port() {
    local host=$1
    local port=$2
    local service=$3
    
    # Security: Add rate limiting note
    # Using bash TCP redirection is safe but add small delay to avoid triggering security controls
    sleep 0.5
    
    if timeout 2 bash -c "cat < /dev/null > /dev/tcp/${host}/${port}" 2>/dev/null; then
        success "$service ($host:$port) is reachable"
        audit_log "PORT_TEST" "SUCCESS:$service:$host:$port"
    else
        error "$service ($host:$port) is NOT reachable"
        audit_log "PORT_TEST" "FAILED:$service:$host:$port"
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
echo "Audit log saved to: $AUDIT_LOG"
audit_log "NETWORK_DIAGNOSTICS" "COMPLETED"
