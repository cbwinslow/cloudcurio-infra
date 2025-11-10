#!/bin/bash

################################################################################
# Automatisch Installation Script
# 
# Description: Installs Automatisch - Open-source Zapier alternative
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
# 
# Features:
#   - Visual workflow builder
#   - 100+ integrations
#   - Self-hosted
#   - REST API support
#
# Requirements:
#   - Ubuntu/Debian-based system
#   - Docker and Docker Compose
#   - 2GB+ RAM
#
# Usage: sudo bash install_automatisch.sh
################################################################################

set -euo pipefail

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Configuration
readonly AUTOMATISCH_DIR="/opt/automatisch"
readonly LOG_FILE="/tmp/automatisch_install_$(date +%Y%m%d_%H%M%S).log"

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

install_docker() {
    if ! command -v docker &> /dev/null; then
        log_info "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        rm get-docker.sh
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_info "Installing Docker Compose..."
        curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    fi
}

install_automatisch() {
    log_info "Installing Automatisch..."
    
    mkdir -p "$AUTOMATISCH_DIR"
    cd "$AUTOMATISCH_DIR"
    
    # Create docker-compose.yml
    cat > docker-compose.yml <<'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:14-alpine
    environment:
      POSTGRES_PASSWORD: automatisch
      POSTGRES_USER: automatisch
      POSTGRES_DB: automatisch
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - automatisch

  automatisch:
    image: automatischio/automatisch:latest
    depends_on:
      - postgres
    environment:
      DATABASE_URL: postgresql://automatisch:automatisch@postgres:5432/automatisch
      APP_ENV: production
      ENCRYPTION_KEY: change-this-to-a-random-string
      WEBHOOK_URL: http://localhost:3000
    ports:
      - "3000:3000"
    volumes:
      - automatisch_data:/app/storage
    networks:
      - automatisch

networks:
  automatisch:

volumes:
  postgres_data:
  automatisch_data:
EOF

    docker-compose up -d || {
        log_error "Failed to start Automatisch"
        exit 1
    }
    
    log_info "Automatisch installed successfully"
}

print_summary() {
    log_info "======================================"
    log_info "Automatisch Installation Complete!"
    log_info "======================================"
    log_info ""
    log_info "Access: http://localhost:3000"
    log_info "Directory: $AUTOMATISCH_DIR"
    log_info ""
    log_info "Management commands:"
    log_info "  cd $AUTOMATISCH_DIR"
    log_info "  docker-compose logs -f"
    log_info "  docker-compose restart"
    log_info "======================================"
}

main() {
    check_root
    install_docker
    install_automatisch
    print_summary
}

trap 'log_error "Installation failed at line $LINENO"' ERR
main "$@"
