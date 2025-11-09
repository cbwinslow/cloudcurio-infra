#!/bin/bash

################################################################################
# Crush Installation Script
# 
# Description: Installs Crush terminal code assistant
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: bash install_crush.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_crush() {
    log_info "Installing Crush..."
    
    # Install via cargo if available
    if command -v cargo &> /dev/null; then
        cargo install crush-repl
    else
        log_info "Installing Rust and Cargo first..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        cargo install crush-repl
    fi
    
    log_info "Crush installed! Usage: crush"
}

main() {
    install_crush
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
