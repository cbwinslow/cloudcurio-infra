#!/bin/bash

################################################################################
# Zabbix Installation Script
# 
# Description: Installs Zabbix monitoring solution (server, frontend, agent)
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
# 
# Features:
#   - Real-time monitoring
#   - Distributed monitoring
#   - Auto-discovery
#   - Flexible alerting
#
# Requirements:
#   - Ubuntu/Debian-based system
#   - MySQL/PostgreSQL
#   - Apache/Nginx
#   - PHP 7.4+
#
# Usage: sudo bash install_zabbix.sh
################################################################################

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Configuration
readonly ZABBIX_VERSION="6.4"
readonly DB_NAME="zabbix"
readonly DB_USER="zabbix"
readonly DB_PASS="zabbix_$(openssl rand -hex 8)"
readonly LOG_FILE="/tmp/zabbix_install_$(date +%Y%m%d_%H%M%S).log"

################################################################################
# Helper Functions
################################################################################

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

check_system() {
    log_info "Checking system requirements..."
    
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot determine OS version"
        exit 1
    fi
    
    . /etc/os-release
    
    if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
        log_error "This script supports Ubuntu/Debian only"
        exit 1
    fi
    
    log_info "System check passed"
}

install_dependencies() {
    log_info "Installing dependencies..."
    
    apt-get update || {
        log_error "Failed to update package list"
        exit 1
    }
    
    apt-get install -y \
        wget \
        curl \
        gnupg2 \
        software-properties-common \
        mysql-server \
        apache2 \
        php \
        php-mysql \
        php-gd \
        php-bcmath \
        php-ctype \
        php-xml \
        php-xmlreader \
        php-xmlwriter \
        php-session \
        php-sockets \
        php-mbstring \
        php-gettext \
        php-ldap || {
        log_error "Failed to install dependencies"
        exit 1
    }
    
    log_info "Dependencies installed successfully"
}

setup_database() {
    log_info "Setting up MySQL database..."
    
    # Start MySQL
    systemctl start mysql || {
        log_error "Failed to start MySQL"
        exit 1
    }
    
    systemctl enable mysql
    
    # Create database and user
    mysql -e "CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;" || log_warn "Database might already exist"
    mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';" || log_warn "User might already exist"
    mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';" || {
        log_error "Failed to grant database privileges"
        exit 1
    }
    mysql -e "FLUSH PRIVILEGES;"
    
    # Save credentials
    echo "DB_PASS=${DB_PASS}" > /root/.zabbix_db_credentials
    chmod 600 /root/.zabbix_db_credentials
    
    log_info "Database setup completed"
}

install_zabbix() {
    log_info "Installing Zabbix ${ZABBIX_VERSION}..."
    
    # Add Zabbix repository
    . /etc/os-release
    
    if [[ "$VERSION_CODENAME" == "focal" ]]; then
        wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu20.04_all.deb
        dpkg -i zabbix-release_6.4-1+ubuntu20.04_all.deb
    elif [[ "$VERSION_CODENAME" == "jammy" ]]; then
        wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
        dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
    else
        log_warn "Using generic Zabbix repository"
        wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
        dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
    fi
    
    apt-get update || {
        log_error "Failed to update package list"
        exit 1
    }
    
    # Install Zabbix server, frontend, and agent
    apt-get install -y \
        zabbix-server-mysql \
        zabbix-frontend-php \
        zabbix-apache-conf \
        zabbix-sql-scripts \
        zabbix-agent || {
        log_error "Failed to install Zabbix"
        exit 1
    }
    
    log_info "Zabbix installed successfully"
}

import_initial_schema() {
    log_info "Importing initial database schema..."
    
    if [[ -f /usr/share/zabbix-sql-scripts/mysql/server.sql.gz ]]; then
        zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -u${DB_USER} -p${DB_PASS} ${DB_NAME} || {
            log_error "Failed to import database schema"
            exit 1
        }
    else
        log_error "Database schema file not found"
        exit 1
    fi
    
    log_info "Database schema imported successfully"
}

configure_zabbix() {
    log_info "Configuring Zabbix server..."
    
    # Configure database connection
    sed -i "s/# DBPassword=/DBPassword=${DB_PASS}/" /etc/zabbix/zabbix_server.conf || {
        log_error "Failed to configure Zabbix server"
        exit 1
    }
    
    # Configure PHP for Zabbix
    sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/*/apache2/php.ini
    sed -i 's/max_input_time = 60/max_input_time = 300/' /etc/php/*/apache2/php.ini
    sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/*/apache2/php.ini
    sed -i 's/post_max_size = 8M/post_max_size = 16M/' /etc/php/*/apache2/php.ini
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/' /etc/php/*/apache2/php.ini
    
    # Set timezone
    echo "date.timezone = UTC" >> /etc/php/*/apache2/php.ini
    
    log_info "Zabbix configured successfully"
}

start_services() {
    log_info "Starting Zabbix services..."
    
    systemctl daemon-reload
    
    # Start and enable services
    systemctl restart zabbix-server zabbix-agent apache2 || {
        log_error "Failed to start services"
        exit 1
    }
    
    systemctl enable zabbix-server zabbix-agent apache2 || {
        log_error "Failed to enable services"
        exit 1
    }
    
    log_info "Services started successfully"
}

verify_installation() {
    log_info "Verifying installation..."
    
    # Check if services are running
    if systemctl is-active --quiet zabbix-server && systemctl is-active --quiet apache2; then
        log_info "All services are running"
    else
        log_warn "Some services may not be running properly"
    fi
    
    # Check web interface
    sleep 5
    if curl -s -o /dev/null -w "%{http_code}" http://localhost/zabbix | grep -q "200"; then
        log_info "Web interface is accessible"
    else
        log_warn "Web interface may not be ready yet"
    fi
}

print_summary() {
    log_info "======================================"
    log_info "Zabbix Installation Complete!"
    log_info "======================================"
    log_info ""
    log_info "Access Zabbix at: http://localhost/zabbix"
    log_info "Default credentials: Admin / zabbix"
    log_info ""
    log_info "Database credentials saved in: /root/.zabbix_db_credentials"
    log_info ""
    log_info "Complete the web setup wizard with these settings:"
    log_info "  Database type: MySQL"
    log_info "  Database host: localhost"
    log_info "  Database name: ${DB_NAME}"
    log_info "  Database user: ${DB_USER}"
    log_info "  Database password: ${DB_PASS}"
    log_info ""
    log_info "Important next steps:"
    log_info "1. Complete the web setup wizard"
    log_info "2. Change the default Admin password"
    log_info "3. Configure monitoring hosts"
    log_info "4. Set up email notifications"
    log_info ""
    log_info "Documentation: https://www.zabbix.com/documentation/"
    log_info "Log file: $LOG_FILE"
    log_info "======================================"
}

################################################################################
# Main Execution
################################################################################

main() {
    log_info "Starting Zabbix installation..."
    
    check_root
    check_system
    install_dependencies
    setup_database
    install_zabbix
    import_initial_schema
    configure_zabbix
    start_services
    verify_installation
    print_summary
    
    log_info "Installation completed successfully!"
}

# Trap errors
trap 'log_error "Installation failed at line $LINENO"' ERR

# Run main function
main "$@"
