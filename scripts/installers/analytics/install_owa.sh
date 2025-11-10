#!/bin/bash

################################################################################
# Open Web Analytics Installation Script
# 
# Description: Installs Open Web Analytics
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_owa.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_owa() {
    log_info "Installing Open Web Analytics..."
    
    # Install web server and PHP
    apt-get update
    apt-get install -y apache2 php libapache2-mod-php php-mysql php-xml php-gd wget unzip
    
    # Download and install OWA
    cd /tmp
    wget https://github.com/Open-Web-Analytics/Open-Web-Analytics/releases/download/1.7.8/owa_1.7.8.tar
    tar -xf owa_1.7.8.tar
    mv owa /var/www/html/
    
    # Set permissions
    chown -R www-data:www-data /var/www/html/owa
    chmod -R 755 /var/www/html/owa
    
    # Install MySQL
    apt-get install -y mysql-server
    
    # Restart Apache
    systemctl restart apache2
    
    log_info "OWA installed! Access: http://localhost/owa"
    log_info "Complete setup through the web interface"
}

main() {
    install_owa
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
