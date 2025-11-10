#!/bin/bash

################################################################################
# Apache Superset Installation Script
# 
# Description: Installs Apache Superset data visualization platform
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_superset.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_superset() {
    log_info "Installing Apache Superset..."
    
    apt-get update
    apt-get install -y python3 python3-pip python3-dev build-essential \
        libssl-dev libffi-dev libsasl2-dev libldap2-dev
    
    pip3 install apache-superset
    
    # Initialize database
    superset db upgrade
    
    # Create admin user
    export FLASK_APP=superset
    superset fab create-admin \
        --username admin \
        --firstname Admin \
        --lastname User \
        --email admin@superset.com \
        --password admin
    
    # Load examples (optional)
    superset load_examples
    
    # Initialize
    superset init
    
    log_info "Superset installed! Run: superset run -h 0.0.0.0 -p 8088"
    log_info "Access: http://localhost:8088 (admin/admin)"
}

main() {
    install_superset
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
