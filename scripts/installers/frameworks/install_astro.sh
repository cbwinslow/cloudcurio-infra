#!/bin/bash

################################################################################
# Astro Installation Script
# 
# Description: Installs Astro static site builder
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: bash install_astro.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_astro() {
    log_info "Installing Astro..."
    
    # Install Node.js if needed
    if ! command -v npm &> /dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt-get install -y nodejs
    fi
    
    # Install Astro CLI globally
    npm install -g astro
    
    log_info "Astro installed!"
    log_info "Create a new project: npm create astro@latest"
}

main() {
    install_astro
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
