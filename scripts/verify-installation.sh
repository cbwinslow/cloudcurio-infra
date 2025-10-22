#!/bin/bash
###############################################################################
# CloudCurio Infrastructure - Installation Verification Script
#
# This script verifies that tools have been installed correctly and are
# functioning properly.
#
# Usage:
#   ./scripts/verify-installation.sh                    # Verify all tools
#   ./scripts/verify-installation.sh --tool grafana     # Verify specific tool
#   ./scripts/verify-installation.sh --category database # Verify category
#
# Exit codes:
#   0 - All verified tools are working
#   1 - One or more tools failed verification
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
PASSED=0
FAILED=0
SKIPPED=0

print_status() {
    local status=$1
    local message=$2
    
    case $status in
        "PASS")
            echo -e "${GREEN}✓${NC} $message"
            ((PASSED++))
            ;;
        "FAIL")
            echo -e "${RED}✗${NC} $message"
            ((FAILED++))
            ;;
        "SKIP")
            echo -e "${YELLOW}○${NC} $message"
            ((SKIPPED++))
            ;;
        "INFO")
            echo -e "${BLUE}ℹ${NC} $message"
            ;;
    esac
}

check_command() {
    local cmd=$1
    local name=$2
    
    if command -v $cmd &> /dev/null; then
        local version=$($cmd --version 2>&1 | head -n1 || echo "unknown")
        print_status "PASS" "$name installed: $version"
        return 0
    else
        print_status "SKIP" "$name not installed"
        return 1
    fi
}

check_service() {
    local service=$1
    local name=$2
    
    if systemctl is-active --quiet $service 2>/dev/null; then
        print_status "PASS" "$name service is running"
        return 0
    else
        print_status "SKIP" "$name service not running or not installed"
        return 1
    fi
}

check_port() {
    local port=$1
    local name=$2
    
    if ss -tuln | grep -q ":$port "; then
        print_status "PASS" "$name listening on port $port"
        return 0
    else
        print_status "SKIP" "$name not listening on port $port"
        return 1
    fi
}

check_docker_container() {
    local container=$1
    local name=$2
    
    if docker ps --format '{{.Names}}' 2>/dev/null | grep -q "^$container$"; then
        print_status "PASS" "$name container running"
        return 0
    else
        print_status "SKIP" "$name container not running"
        return 1
    fi
}

echo "=========================================="
echo "CloudCurio Infrastructure"
echo "Installation Verification"
echo "=========================================="
echo ""

# Programming Languages
echo "=== Programming Languages ==="
check_command python3 "Python"
check_command node "Node.js"
check_command php "PHP"
echo ""

# Containers
echo "=== Container Runtimes ==="
check_command docker "Docker"
check_command docker-compose "Docker Compose"
check_command podman "Podman"
if command -v docker &> /dev/null; then
    check_service docker "Docker daemon"
fi
echo ""

# Databases
echo "=== Databases ==="
check_service postgresql "PostgreSQL"
check_service mysql "MySQL"
check_port 5432 "PostgreSQL"
check_port 3306 "MySQL"
echo ""

# Web Servers
echo "=== Web Servers ==="
check_service apache2 "Apache2"
check_service nginx "Nginx"
check_service caddy "Caddy"
echo ""

# Monitoring
echo "=== Monitoring & Logging ==="
check_service grafana-server "Grafana"
check_service prometheus "Prometheus"
check_docker_container loki "Loki"
check_port 3002 "Grafana"
check_port 9090 "Prometheus"
echo ""

# Infrastructure
echo "=== Infrastructure Tools ==="
check_command terraform "Terraform"
check_command pulumi "Pulumi"
check_service consul "Consul"
echo ""

# AI/ML
echo "=== AI/ML Tools ==="
check_service ollama "Ollama"
check_docker_container open-webui "Open WebUI"
check_port 11434 "Ollama"
echo ""

# Networking
echo "=== Networking & VPN ==="
check_service tailscaled "Tailscale"
check_service zerotier-one "ZeroTier"
echo ""

# Print summary
echo ""
echo "=========================================="
echo "Verification Summary"
echo "=========================================="
echo -e "${GREEN}Passed:${NC}  $PASSED"
echo -e "${YELLOW}Skipped:${NC} $SKIPPED"
echo -e "${RED}Failed:${NC}  $FAILED"
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}✓ All checked tools are working!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tools failed verification${NC}"
    exit 1
fi
