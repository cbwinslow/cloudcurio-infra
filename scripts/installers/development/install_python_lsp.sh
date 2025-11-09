#!/bin/bash

################################################################################
# Python LSP Installation Script
# 
# Description: Installs Python Language Server (pylsp)
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_python_lsp.sh
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

install_python_lsp() {
    log_info "Installing Python Language Server..."
    apt-get update
    apt-get install -y python3 python3-pip
    pip3 install 'python-lsp-server[all]'
    log_info "Python LSP installed successfully!"
    log_info "Usage: pylsp"
}

main() {
    check_root
    install_python_lsp
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
