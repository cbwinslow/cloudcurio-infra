#!/bin/bash

################################################################################
# Hugo Installation Script
# 
# Description: Installs Hugo static site generator
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_hugo.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'
readonly HUGO_VERSION="0.121.1"

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_hugo() {
    log_info "Installing Hugo ${HUGO_VERSION}..."
    
    cd /tmp
    wget "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
    tar -xzf "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
    mv hugo /usr/local/bin/
    
    log_info "Hugo installed! Version: $(hugo version)"
    log_info "Usage: hugo new site mysite"
}

main() {
    install_hugo
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
