#!/bin/bash

################################################################################
# OliveTin Installation Script
# 
# Description: Installs OliveTin - Web UI for running Linux commands
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_olivetin.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'
readonly VERSION="2023.12.17"

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_root() {
    [[ $EUID -ne 0 ]] && log_error "Must run as root" && exit 1
}

install_olivetin() {
    log_info "Installing OliveTin..."
    
    # Detect architecture
    ARCH=$(dpkg --print-architecture)
    
    wget "https://github.com/OliveTin/OliveTin/releases/download/${VERSION}/OliveTin_${VERSION}_linux_${ARCH}.deb"
    dpkg -i "OliveTin_${VERSION}_linux_${ARCH}.deb"
    rm "OliveTin_${VERSION}_linux_${ARCH}.deb"
    
    # Create sample config
    mkdir -p /etc/OliveTin
    cat > /etc/OliveTin/config.yaml <<'EOF'
# OliveTin Configuration
listenAddressWebUI: 0.0.0.0:1337
actions:
  - title: Restart Nginx
    shell: systemctl restart nginx
    
  - title: Update System
    shell: apt-get update && apt-get upgrade -y
    
  - title: Disk Usage
    shell: df -h
EOF
    
    systemctl enable OliveTin
    systemctl start OliveTin
    
    log_info "OliveTin installed! Access: http://localhost:1337"
}

main() {
    check_root
    install_olivetin
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
