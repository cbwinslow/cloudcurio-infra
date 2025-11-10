#!/bin/bash

################################################################################
# TypeScript LSP Installation Script
# 
# Description: Installs TypeScript Language Server
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_typescript_lsp.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_root() {
    [[ $EUID -ne 0 ]] && log_error "Must run as root" && exit 1
}

install_node() {
    if ! command -v node &> /dev/null; then
        log_info "Installing Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt-get install -y nodejs
    fi
}

install_typescript_lsp() {
    log_info "Installing TypeScript Language Server..."
    npm install -g typescript typescript-language-server
    log_info "TypeScript LSP installed successfully!"
    log_info "Usage: typescript-language-server --stdio"
}

main() {
    check_root
    install_node
    install_typescript_lsp
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
