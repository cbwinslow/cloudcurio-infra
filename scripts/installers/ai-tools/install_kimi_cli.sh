#!/bin/bash

################################################################################
# Kimi CLI Installation Script
# 
# Description: Installs Moonshot AI Kimi CLI tool
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: bash install_kimi_cli.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_kimi_cli() {
    log_info "Installing Kimi CLI..."
    
    pip3 install kimi-cli
    
    log_info "Kimi CLI installed! Usage: kimi"
}

main() {
    install_kimi_cli
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
