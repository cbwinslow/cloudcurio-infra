#!/bin/bash

################################################################################
# Parseable Installation Script
# 
# Description: Installs Parseable log analytics platform
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_parseable.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_parseable() {
    log_info "Installing Parseable..."
    
    # Download binary
    cd /tmp
    wget https://github.com/parseablehq/parseable/releases/latest/download/parseable-linux-amd64
    chmod +x parseable-linux-amd64
    mv parseable-linux-amd64 /usr/local/bin/parseable
    
    # Create data directory
    mkdir -p /var/parseable/data
    
    # Create systemd service
    cat > /etc/systemd/system/parseable.service <<'EOF'
[Unit]
Description=Parseable Log Analytics
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/parseable local-store
Environment="P_ADDR=0.0.0.0:8000"
Environment="P_STORAGE__FILESYSTEM__ROOT=/var/parseable/data"
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable parseable
    systemctl start parseable
    
    log_info "Parseable installed! Access: http://localhost:8000"
}

main() {
    install_parseable
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
