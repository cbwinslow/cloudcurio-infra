#!/bin/bash

################################################################################
# Codex CLI Installation Script
# 
# Description: Installs OpenAI Codex CLI tool
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_codex_cli.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_codex_cli() {
    log_info "Installing Codex CLI..."
    
    # Install via pip
    apt-get update
    apt-get install -y python3-pip
    pip3 install openai-codex-cli
    
    log_info "Codex CLI installed!"
    log_warn "Set your OpenAI API key: export OPENAI_API_KEY='your-key'"
    log_info "Usage: codex 'your prompt'"
}

main() {
    install_codex_cli
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
