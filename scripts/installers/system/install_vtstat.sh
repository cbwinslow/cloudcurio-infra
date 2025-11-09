#!/bin/bash

################################################################################
# vtstat Installation Script
# 
# Description: Installs vtstat - Terminal statistics display
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: bash install_vtstat.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_vtstat() {
    log_info "Installing vtstat..."
    
    cd /tmp
    git clone https://github.com/codecat/vtstat.git
    cd vtstat
    
    # Build and install
    if command -v cargo &> /dev/null; then
        cargo build --release
        cp target/release/vtstat /usr/local/bin/
    else
        log_info "Installing Rust first..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        cargo build --release
        cp target/release/vtstat /usr/local/bin/
    fi
    
    log_info "vtstat installed! Usage: vtstat"
}

main() {
    install_vtstat
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
