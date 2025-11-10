#!/bin/bash

################################################################################
# Matchering Installation Script
# 
# Description: Installs Matchering - AI-powered audio mastering
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_matchering.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_matchering() {
    log_info "Installing Matchering..."
    
    # Install dependencies
    apt-get update
    apt-get install -y python3 python3-pip ffmpeg
    
    # Install matchering
    pip3 install matchering
    
    log_info "Matchering installed!"
    log_info "Usage: matchering target.wav reference.wav result.wav"
}

main() {
    install_matchering
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
