#!/bin/bash

################################################################################
# Next.js Installation Script
# 
# Description: Installs Next.js React framework
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: bash install_nextjs.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_nextjs() {
    log_info "Installing Next.js..."
    
    # Install Node.js if needed
    if ! command -v npm &> /dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt-get install -y nodejs
    fi
    
    # Install create-next-app globally
    npm install -g create-next-app
    
    log_info "Next.js installed!"
    log_info "Create a new app: npx create-next-app@latest my-app"
}

main() {
    install_nextjs
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
