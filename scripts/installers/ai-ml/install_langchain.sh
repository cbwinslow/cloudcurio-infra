#!/bin/bash

################################################################################
# LangChain Installation Script
# 
# Description: Installs LangChain Python library
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: bash install_langchain.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_langchain() {
    log_info "Installing LangChain..."
    
    # Install Python if needed
    if ! command -v pip3 &> /dev/null; then
        apt-get update
        apt-get install -y python3-pip
    fi
    
    # Install LangChain and common dependencies
    pip3 install langchain langchain-community langchain-openai
    
    log_info "LangChain installed!"
    log_info "Usage: import langchain in Python"
}

main() {
    install_langchain
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
