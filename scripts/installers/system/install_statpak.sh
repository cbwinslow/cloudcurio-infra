#!/bin/bash

################################################################################
# statpak Installation Script
# 
# Description: Installs statpak - System statistics package
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: bash install_statpak.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_statpak() {
    log_info "Installing system statistics tools..."
    
    apt-get update
    apt-get install -y \
        sysstat \
        htop \
        iotop \
        nethogs \
        iftop \
        atop \
        dstat \
        nmon
    
    log_info "Statistics tools installed!"
    log_info "Available commands: htop, iotop, nethogs, iftop, atop, dstat, nmon"
}

main() {
    install_statpak
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
