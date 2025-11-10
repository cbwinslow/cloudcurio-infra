#!/bin/bash

################################################################################
# Metabase Installation Script
# 
# Description: Installs Metabase Business Intelligence platform
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_metabase.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_java() {
    log_info "Installing Java..."
    apt-get update
    apt-get install -y openjdk-11-jre
}

install_metabase() {
    log_info "Installing Metabase..."
    
    mkdir -p /opt/metabase
    cd /opt/metabase
    wget https://downloads.metabase.com/latest/metabase.jar
    
    # Create systemd service
    cat > /etc/systemd/system/metabase.service <<'EOF'
[Unit]
Description=Metabase
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/metabase
ExecStart=/usr/bin/java -jar metabase.jar
Restart=always
Environment="MB_DB_FILE=/opt/metabase/metabase.db"

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable metabase
    systemctl start metabase
    
    log_info "Metabase installed! Access: http://localhost:3000"
}

main() {
    install_java
    install_metabase
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
