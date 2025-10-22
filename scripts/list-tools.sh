#!/bin/bash
###############################################################################
# CloudCurio Infrastructure - List All Available Tools
#
# This script displays all available tools organized by category.
#
# Usage:
#   ./scripts/list-tools.sh
#   ./scripts/list-tools.sh --tags    # Show with Ansible tags
#   ./scripts/list-tools.sh --ports   # Show with default ports
###############################################################################

set -e

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SHOW_TAGS=false
SHOW_PORTS=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --tags)
            SHOW_TAGS=true
            shift
            ;;
        --ports)
            SHOW_PORTS=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

clear
echo -e "${CYAN}=========================================="
echo "CloudCurio Infrastructure"
echo "Available Tools"
echo -e "==========================================${NC}"
echo ""

print_tool() {
    local name=$1
    local tag=$2
    local port=$3
    
    echo -n "  • $name"
    if [ "$SHOW_TAGS" = true ]; then
        echo -n " [tag: $tag]"
    fi
    if [ "$SHOW_PORTS" = true ] && [ -n "$port" ]; then
        echo -n " (port: $port)"
    fi
    echo ""
}

echo -e "${BLUE}Programming Languages & Runtimes (4)${NC}"
print_tool "Python 3.11+" "python" ""
print_tool "UV Package Manager" "uv" ""
print_tool "Node.js 20" "nodejs" ""
print_tool "PHP 8+" "php" ""
echo ""

echo -e "${BLUE}Container & Orchestration (3)${NC}"
print_tool "Docker Engine" "docker" ""
print_tool "Docker Compose" "docker-compose" ""
print_tool "Podman" "podman" ""
echo ""

echo -e "${BLUE}Databases (6)${NC}"
print_tool "PostgreSQL 15" "postgresql" "5432"
print_tool "MySQL 8.0" "mysql" "3306"
print_tool "ClickHouse" "clickhouse" "8123"
print_tool "InfluxDB 2.x" "influxdb" "8086"
print_tool "TimescaleDB" "timescaledb" "5432"
print_tool "VictoriaMetrics" "victoriametrics" "8428"
echo ""

echo -e "${BLUE}Web Servers & Reverse Proxies (4)${NC}"
print_tool "Nginx" "nginx" "80"
print_tool "Apache2" "apache2" "80"
print_tool "Caddy" "caddy" "80"
print_tool "Traefik" "traefik" "80"
echo ""

echo -e "${BLUE}AI/ML Tools (5)${NC}"
print_tool "Ollama" "ollama" "11434"
print_tool "LocalAI" "localai" "8080"
print_tool "Open WebUI" "openwebui" "3000"
print_tool "Flowise" "flowise" "3001"
print_tool "Haystack" "haystack" ""
echo ""

echo -e "${BLUE}Monitoring & Logging (8)${NC}"
print_tool "Grafana" "grafana" "3002"
print_tool "Prometheus" "prometheus" "9090"
print_tool "Loki" "loki" "3100"
print_tool "Elasticsearch" "elasticsearch" "9200"
print_tool "OpenSearch" "opensearch" "9200"
print_tool "Graylog" "graylog" "9000"
print_tool "Logfire" "logfire" ""
print_tool "Graphite" "graphite" "8085"
echo ""

echo -e "${BLUE}Infrastructure Tools (4)${NC}"
print_tool "Terraform" "terraform" ""
print_tool "Pulumi" "pulumi" ""
print_tool "Consul" "consul" "8500"
print_tool "Kong" "kong" "8000"
echo ""

echo -e "${BLUE}Security & Authentication (3)${NC}"
print_tool "Keycloak" "keycloak" "8080"
print_tool "Bitwarden (Vaultwarden)" "bitwarden" "8200"
print_tool "Vault" "vault" "8200"
echo ""

echo -e "${CYAN}==========================================${NC}"
echo ""
echo "Total: 77 roles covering 100+ tools"
echo ""
echo "To install tools:"
echo "  ansible-playbook -i inventory/hosts.ini sites.yml --tags 'tag1,tag2'"
echo ""
echo "For interactive installation:"
echo "  python3 tui/installer.py"
echo ""
