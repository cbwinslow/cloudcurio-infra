#!/bin/bash

################################################################################
# Kibitzr Installation Script
# 
# Description: Installs Kibitzr - Personal Web Assistant
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_kibitzr.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_kibitzr() {
    log_info "Installing Kibitzr..."
    apt-get update
    apt-get install -y python3 python3-pip
    pip3 install kibitzr
    
    # Create sample config
    mkdir -p ~/.config/kibitzr
    cat > ~/.config/kibitzr/kibitzr.yml <<'EOF'
checks:
  - name: Example check
    url: https://example.com
    notify:
      - echo
EOF
    
    log_info "Kibitzr installed! Config: ~/.config/kibitzr/kibitzr.yml"
    log_info "Usage: kibitzr"
}

main() {
    install_kibitzr
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
