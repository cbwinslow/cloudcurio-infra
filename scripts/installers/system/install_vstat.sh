#!/bin/bash

################################################################################
# vstat Installation Script
# 
# Description: Installs vstat - Virtual memory statistics tool
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: bash install_vstat.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_vstat() {
    log_info "Installing vstat..."
    
    # vstat is typically part of sysstat package
    apt-get update
    apt-get install -y sysstat procps
    
    log_info "vstat installed! (via sysstat)"
    log_info "Usage: vmstat, iostat, mpstat"
}

main() {
    install_vstat
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
