#!/bin/bash

################################################################################
# Apache Cassandra Installation Script
# 
# Description: Installs Apache Cassandra NoSQL database
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_cassandra.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'
readonly LOG_FILE="/tmp/cassandra_install_$(date +%Y%m%d_%H%M%S).log"

log_info() { echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"; }

check_root() {
    [[ $EUID -ne 0 ]] && log_error "Must run as root" && exit 1
}

install_cassandra() {
    log_info "Installing Cassandra..."
    
    # Add repository
    wget -q -O - https://www.apache.org/dist/cassandra/KEYS | apt-key add -
    echo "deb https://debian.cassandra.apache.org 41x main" > /etc/apt/sources.list.d/cassandra.list
    
    apt-get update
    apt-get install -y cassandra
    
    systemctl enable cassandra
    systemctl start cassandra
    
    log_info "Cassandra installed. CQL port: 9042"
}

main() {
    check_root
    install_cassandra
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
