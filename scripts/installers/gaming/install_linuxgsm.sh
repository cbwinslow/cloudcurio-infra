#!/bin/bash

################################################################################
# LinuxGSM Installation Script
# 
# Description: Installs LinuxGSM - Game server manager
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_linuxgsm.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_root() {
    [[ $EUID -ne 0 ]] && log_error "Must run as root" && exit 1
}

install_dependencies() {
    log_info "Installing dependencies..."
    dpkg --add-architecture i386
    apt-get update
    apt-get install -y curl wget file tar bzip2 gzip unzip bsdmainutils \
        python3 util-linux ca-certificates binutils bc jq tmux lib32gcc1 \
        lib32stdc++6 netcat
}

install_linuxgsm() {
    log_info "Installing LinuxGSM..."
    
    # Create linuxgsm user
    if ! id "linuxgsm" &>/dev/null; then
        adduser --disabled-password --gecos "" linuxgsm
    fi
    
    # Install LinuxGSM
    su - linuxgsm -c "wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh"
    
    log_info "LinuxGSM installed successfully!"
    log_info "Switch to linuxgsm user: su - linuxgsm"
    log_info "Install a game server: ./linuxgsm.sh gameserver"
    log_info "Example: ./linuxgsm.sh csgoserver"
}

main() {
    check_root
    install_dependencies
    install_linuxgsm
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
