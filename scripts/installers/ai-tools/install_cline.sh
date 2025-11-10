#!/bin/bash

################################################################################
# Cline Installation Script
# 
# Description: Installs Cline AI coding assistant
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_cline.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_cline() {
    log_info "Installing Cline..."
    
    # Install Node.js if needed
    if ! command -v npm &> /dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt-get install -y nodejs
    fi
    
    npm install -g @cline/cli
    
    log_info "Cline installed! Usage: cline"
}

main() {
    install_cline
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
