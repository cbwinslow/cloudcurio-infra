#!/bin/bash

################################################################################
# Gemini CLI Installation Script
# 
# Description: Installs Google Gemini CLI tool
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_gemini_cli.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_gemini_cli() {
    log_info "Installing Gemini CLI..."
    
    # Install via pip
    if command -v pip3 &> /dev/null; then
        pip3 install gemini-cli
    else
        apt-get update
        apt-get install -y python3-pip
        pip3 install gemini-cli
    fi
    
    log_info "Gemini CLI installed successfully!"
    log_warn "Set your API key: export GEMINI_API_KEY='your-api-key'"
    log_info "Usage: gemini 'your prompt here'"
}

main() {
    install_gemini_cli
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
