#!/bin/bash
###############################################################################
# CloudCurio Infrastructure - View Installation Status
#
# This script displays the current status of installed tools and services.
#
# Features:
# - Shows which tools are installed
# - Displays service status (running/stopped)
# - Shows port bindings
# - Displays Docker container status
# - Shows version information
#
# Usage:
#   ./scripts/view-status.sh
#   ./scripts/view-status.sh --json     # Output in JSON format
#   ./scripts/view-status.sh --category database  # Show only database tools
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Output format
OUTPUT_JSON=false
CATEGORY_FILTER=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            OUTPUT_JSON=true
            shift
            ;;
        --category)
            CATEGORY_FILTER="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Function to check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check service status
service_status() {
    local service=$1
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo "running"
    elif systemctl is-enabled --quiet "$service" 2>/dev/null; then
        echo "stopped"
    else
        echo "not_installed"
    fi
}

# Function to get version
get_version() {
    local cmd=$1
    if command_exists "$cmd"; then
        $cmd --version 2>&1 | head -n1 | grep -oP '\d+\.\d+(\.\d+)?' || echo "installed"
    else
        echo "not_installed"
    fi
}

# JSON output functions
json_start() {
    echo "{"
    echo '  "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",'
    echo '  "hostname": "'$(hostname)'",'
    echo '  "tools": {'
}

json_end() {
    echo "  }"
    echo "}"
}

# Clear screen and print header
if [ "$OUTPUT_JSON" = false ]; then
    clear
    echo -e "${CYAN}=========================================="
    echo "CloudCurio Infrastructure"
    echo "Installation Status"
    echo -e "==========================================${NC}"
    echo ""
    echo "Hostname: $(hostname)"
    echo "Date: $(date)"
    echo ""
fi

# Start JSON if needed
if [ "$OUTPUT_JSON" = true ]; then
    json_start
fi

# Programming Languages
if [ -z "$CATEGORY_FILTER" ] || [ "$CATEGORY_FILTER" = "languages" ]; then
    if [ "$OUTPUT_JSON" = false ]; then
        echo -e "${BLUE}=== Programming Languages ===${NC}"
    fi
    
    PYTHON_VERSION=$(get_version python3)
    if [ "$OUTPUT_JSON" = false ]; then
        if [ "$PYTHON_VERSION" != "not_installed" ]; then
            echo -e "${GREEN}✓${NC} Python: $PYTHON_VERSION"
        else
            echo -e "${RED}✗${NC} Python: Not installed"
        fi
    fi
    
    NODE_VERSION=$(get_version node)
    if [ "$OUTPUT_JSON" = false ]; then
        if [ "$NODE_VERSION" != "not_installed" ]; then
            echo -e "${GREEN}✓${NC} Node.js: $NODE_VERSION"
        else
            echo -e "${RED}✗${NC} Node.js: Not installed"
        fi
    fi
    
    PHP_VERSION=$(get_version php)
    if [ "$OUTPUT_JSON" = false ]; then
        if [ "$PHP_VERSION" != "not_installed" ]; then
            echo -e "${GREEN}✓${NC} PHP: $PHP_VERSION"
        else
            echo -e "${RED}✗${NC} PHP: Not installed"
        fi
        echo ""
    fi
fi

# Containers
if [ -z "$CATEGORY_FILTER" ] || [ "$CATEGORY_FILTER" = "containers" ]; then
    if [ "$OUTPUT_JSON" = false ]; then
        echo -e "${BLUE}=== Container Runtimes ===${NC}"
    fi
    
    DOCKER_VERSION=$(get_version docker)
    DOCKER_STATUS=$(service_status docker)
    if [ "$OUTPUT_JSON" = false ]; then
        if [ "$DOCKER_VERSION" != "not_installed" ]; then
            echo -e "${GREEN}✓${NC} Docker: $DOCKER_VERSION [$DOCKER_STATUS]"
            
            # Show docker containers if docker is running
            if [ "$DOCKER_STATUS" = "running" ]; then
                CONTAINER_COUNT=$(docker ps --format '{{.Names}}' 2>/dev/null | wc -l)
                echo "  Running containers: $CONTAINER_COUNT"
                if [ $CONTAINER_COUNT -gt 0 ]; then
                    docker ps --format '  - {{.Names}} ({{.Image}})' 2>/dev/null
                fi
            fi
        else
            echo -e "${RED}✗${NC} Docker: Not installed"
        fi
    fi
    
    PODMAN_VERSION=$(get_version podman)
    if [ "$OUTPUT_JSON" = false ]; then
        if [ "$PODMAN_VERSION" != "not_installed" ]; then
            echo -e "${GREEN}✓${NC} Podman: $PODMAN_VERSION"
        else
            echo -e "${RED}✗${NC} Podman: Not installed"
        fi
        echo ""
    fi
fi

# Databases
if [ -z "$CATEGORY_FILTER" ] || [ "$CATEGORY_FILTER" = "databases" ]; then
    if [ "$OUTPUT_JSON" = false ]; then
        echo -e "${BLUE}=== Databases ===${NC}"
    fi
    
    PG_STATUS=$(service_status postgresql)
    if [ "$OUTPUT_JSON" = false ]; then
        if [ "$PG_STATUS" != "not_installed" ]; then
            PG_VERSION=$(psql --version 2>/dev/null | grep -oP '\d+\.\d+' || echo "unknown")
            echo -e "${GREEN}✓${NC} PostgreSQL: $PG_VERSION [$PG_STATUS]"
            if [ "$PG_STATUS" = "running" ] && ss -tuln | grep -q ":5432 "; then
                echo "  Listening on port 5432"
            fi
        else
            echo -e "${RED}✗${NC} PostgreSQL: Not installed"
        fi
    fi
    
    MYSQL_STATUS=$(service_status mysql)
    if [ "$OUTPUT_JSON" = false ]; then
        if [ "$MYSQL_STATUS" != "not_installed" ]; then
            MYSQL_VERSION=$(mysql --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1 || echo "unknown")
            echo -e "${GREEN}✓${NC} MySQL: $MYSQL_VERSION [$MYSQL_STATUS]"
            if [ "$MYSQL_STATUS" = "running" ] && ss -tuln | grep -q ":3306 "; then
                echo "  Listening on port 3306"
            fi
        else
            echo -e "${RED}✗${NC} MySQL: Not installed"
        fi
        echo ""
    fi
fi

# Monitoring
if [ -z "$CATEGORY_FILTER" ] || [ "$CATEGORY_FILTER" = "monitoring" ]; then
    if [ "$OUTPUT_JSON" = false ]; then
        echo -e "${BLUE}=== Monitoring & Logging ===${NC}"
    fi
    
    GRAFANA_STATUS=$(service_status grafana-server)
    if [ "$OUTPUT_JSON" = false ]; then
        if [ "$GRAFANA_STATUS" != "not_installed" ]; then
            echo -e "${GREEN}✓${NC} Grafana: [$GRAFANA_STATUS]"
            if [ "$GRAFANA_STATUS" = "running" ] && ss -tuln | grep -q ":3002 "; then
                echo "  Web UI: http://localhost:3002"
            fi
        else
            echo -e "${RED}✗${NC} Grafana: Not installed"
        fi
    fi
    
    PROMETHEUS_STATUS=$(service_status prometheus)
    if [ "$OUTPUT_JSON" = false ]; then
        if [ "$PROMETHEUS_STATUS" != "not_installed" ]; then
            echo -e "${GREEN}✓${NC} Prometheus: [$PROMETHEUS_STATUS]"
            if [ "$PROMETHEUS_STATUS" = "running" ] && ss -tuln | grep -q ":9090 "; then
                echo "  Web UI: http://localhost:9090"
            fi
        else
            echo -e "${RED}✗${NC} Prometheus: Not installed"
        fi
        echo ""
    fi
fi

# Summary
if [ "$OUTPUT_JSON" = false ]; then
    echo -e "${CYAN}==========================================${NC}"
    echo ""
    echo "For detailed information, run:"
    echo "  systemctl status <service>"
    echo "  docker ps -a"
    echo "  <command> --version"
    echo ""
fi

# End JSON if needed
if [ "$OUTPUT_JSON" = true ]; then
    json_end
fi
