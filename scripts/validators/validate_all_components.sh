#!/bin/bash
# Validation script for all installed components
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
echo "CloudCurio Infrastructure - Component Validator"
echo "=============================================="
echo ""

# Track validation results
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

check_component() {
    local component=$1
    local check_command=$2
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if eval "$check_command" &> /dev/null; then
        success "$component is installed and working"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        error "$component is NOT installed or not working"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        return 1
    fi
}

check_service() {
    local service=$1
    local service_name=$2
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if systemctl is-active --quiet "$service_name"; then
        success "$service service is running"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        error "$service service is NOT running"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        return 1
    fi
}

echo "=== Networking Components ==="
check_component "ZeroTier" "zerotier-cli --version"
check_service "ZeroTier" "zerotier-one"
check_component "SSH" "which ssh"
echo ""

echo "=== Container Tools ==="
check_component "Docker" "docker --version"
check_service "Docker" "docker"
check_component "Docker Compose" "docker compose version"
echo ""

echo "=== Monitoring Stack ==="
check_component "Prometheus" "test -f /usr/local/bin/prometheus"
check_service "Prometheus" "prometheus" || true
check_component "Grafana" "test -f /usr/sbin/grafana-server"
check_service "Grafana" "grafana-server" || true
check_component "Loki" "test -f /usr/local/bin/loki"
check_service "Loki" "loki" || true
echo ""

echo "=== Security Tools ==="
check_component "Suricata" "suricata --version"
check_service "Suricata" "suricata" || true
check_component "Wazuh Agent" "test -f /var/ossec/bin/wazuh-control"
check_service "Wazuh" "wazuh-agent" || true
check_component "fail2ban" "fail2ban-client --version"
check_service "fail2ban" "fail2ban" || true
echo ""

echo "=== Web Servers ==="
check_component "Nginx" "nginx -v"
check_service "Nginx" "nginx" || true
check_component "Apache" "apache2 -v"
check_service "Apache" "apache2" || true
check_component "Caddy" "caddy version"
check_service "Caddy" "caddy" || true
echo ""

echo "=== Automation Tools ==="
check_component "SaltStack" "salt-call --version"
check_service "Salt Minion" "salt-minion" || true
check_component "n8n" "which n8n"
check_service "n8n" "n8n" || true
echo ""

echo "=== AI/ML Tools ==="
check_component "AnythingLLM" "test -d /opt/anythingllm"
check_component "LocalAI" "test -f /usr/local/bin/local-ai"
check_component "Ollama" "ollama --version"
check_service "Ollama" "ollama" || true
echo ""

echo "=== Infrastructure Tools ==="
check_component "Git" "git --version"
check_component "Ansible" "ansible --version"
check_component "Terraform" "terraform --version"
check_component "Chezmoi" "chezmoi --version"
check_component "jq" "jq --version"
check_component "curl" "curl --version"
check_component "wget" "wget --version"
echo ""

echo "=== Development Tools ==="
check_component "Python3" "python3 --version"
check_component "pip3" "pip3 --version"
check_component "Node.js" "node --version"
check_component "npm" "npm --version"
check_component "Go" "go version"
echo ""

echo "=============================================="
echo "Validation Summary"
echo "=============================================="
echo "Total Checks: $TOTAL_CHECKS"
echo -e "${GREEN}Passed: $PASSED_CHECKS${NC}"
echo -e "${RED}Failed: $FAILED_CHECKS${NC}"
echo ""

if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e "${GREEN}All components are properly installed!${NC}"
    exit 0
else
    echo -e "${YELLOW}Some components are missing or not working.${NC}"
    echo "Run the installers to set up missing components:"
    echo "  bash scripts/master_installer.sh"
    exit 1
fi
