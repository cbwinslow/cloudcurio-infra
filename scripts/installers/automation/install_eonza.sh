#!/bin/bash

################################################################################
# Eonza Installation Script
# 
# Description: Installs Eonza - Lightweight automation software
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_eonza.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_eonza() {
    log_info "Installing Eonza..."
    
    # Download and install
    cd /tmp
    wget https://github.com/gentee/eonza/releases/latest/download/eonza-linux-amd64.zip
    unzip eonza-linux-amd64.zip
    chmod +x eonza
    mv eonza /usr/local/bin/
    
    # Create systemd service
    cat > /etc/systemd/system/eonza.service <<'EOF'
[Unit]
Description=Eonza Automation
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/eonza
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable eonza
    systemctl start eonza
    
    log_info "Eonza installed! Access: http://localhost:3234"
}

main() {
    install_eonza
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
