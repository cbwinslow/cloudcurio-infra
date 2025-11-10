#!/bin/bash

################################################################################
# LangGraph Installation Script
# 
# Description: Installs LangGraph - Library for building stateful LLM apps
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: bash install_langgraph.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_langgraph() {
    log_info "Installing LangGraph..."
    
    # Install Python if needed
    if ! command -v pip3 &> /dev/null; then
        apt-get update
        apt-get install -y python3-pip
    fi
    
    # Install LangChain first (dependency)
    pip3 install langchain
    
    # Install LangGraph
    pip3 install langgraph
    
    log_info "LangGraph installed!"
    log_info "Usage: import langgraph in Python"
}

main() {
    install_langgraph
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
