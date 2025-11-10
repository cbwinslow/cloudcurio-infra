#!/bin/bash

################################################################################
# OpenNMS Installation Script
# 
# Description: Installs OpenNMS Network Management System
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
# 
# Features:
#   - Enterprise network monitoring
#   - Service assurance
#   - Performance management
#   - Event management
#
# Requirements:
#   - Ubuntu/Debian-based system
#   - PostgreSQL
#   - Java 11+
#   - Minimum 4GB RAM
#
# Usage: sudo bash install_opennms.sh
################################################################################

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Configuration
readonly OPENNMS_VERSION="31.0.8"
readonly OPENNMS_HOME="/opt/opennms"
readonly LOG_FILE="/tmp/opennms_install_$(date +%Y%m%d_%H%M%S).log"

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
    
    # Check OS
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot determine OS version"
        exit 1
    fi
    
    # Check available memory
    local total_mem=$(free -m | awk '/^Mem:/{print $2}')
    if [[ $total_mem -lt 4096 ]]; then
        log_warn "System has less than 4GB RAM. OpenNMS may not perform optimally."
    fi
    
    # Check disk space
    local disk_space=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
    if [[ $disk_space -lt 10 ]]; then
        log_error "Insufficient disk space. At least 10GB required."
        exit 1
    fi
    
    log_info "System requirements check passed"
}

install_dependencies() {
    log_info "Installing dependencies..."
    
    apt-get update || {
        log_error "Failed to update package list"
        exit 1
    }
    
    apt-get install -y \
        wget \
        gnupg2 \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        postgresql \
        openjdk-11-jdk || {
        log_error "Failed to install dependencies"
        exit 1
    }
    
    log_info "Dependencies installed successfully"
}

setup_postgresql() {
    log_info "Setting up PostgreSQL database..."
    
    # Start PostgreSQL
    systemctl start postgresql || {
        log_error "Failed to start PostgreSQL"
        exit 1
    }
    
    systemctl enable postgresql
    
    # Create OpenNMS database and user
    sudo -u postgres psql -c "CREATE DATABASE opennms;" 2>/dev/null || log_warn "Database might already exist"
    sudo -u postgres psql -c "CREATE USER opennms WITH PASSWORD 'opennms';" 2>/dev/null || log_warn "User might already exist"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE opennms TO opennms;" || {
        log_error "Failed to grant database privileges"
        exit 1
    }
    
    log_info "PostgreSQL setup completed"
}

install_opennms() {
    log_info "Installing OpenNMS..."
    
    # Add OpenNMS repository
    wget -O - https://debian.opennms.org/OPENNMS-GPG-KEY | apt-key add - || {
        log_error "Failed to add OpenNMS GPG key"
        exit 1
    }
    
    add-apt-repository "deb https://debian.opennms.org stable main" || {
        log_error "Failed to add OpenNMS repository"
        exit 1
    }
    
    apt-get update || {
        log_error "Failed to update package list"
        exit 1
    }
    
    apt-get install -y opennms || {
        log_error "Failed to install OpenNMS"
        exit 1
    }
    
    log_info "OpenNMS installed successfully"
}

configure_opennms() {
    log_info "Configuring OpenNMS..."
    
    # Set Java home
    if [[ -f /etc/default/opennms ]]; then
        echo 'JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> /etc/default/opennms
    fi
    
    # Initialize database
    /usr/share/opennms/bin/runjava -s || {
        log_error "Failed to set Java"
        exit 1
    }
    
    /usr/share/opennms/bin/install -dis || {
        log_error "Failed to initialize OpenNMS database"
        exit 1
    }
    
    log_info "OpenNMS configured successfully"
}

start_opennms() {
    log_info "Starting OpenNMS services..."
    
    systemctl daemon-reload
    systemctl enable opennms || {
        log_error "Failed to enable OpenNMS service"
        exit 1
    }
    
    systemctl start opennms || {
        log_error "Failed to start OpenNMS service"
        exit 1
    }
    
    log_info "OpenNMS service started successfully"
}

verify_installation() {
    log_info "Verifying installation..."
    
    # Wait for OpenNMS to start
    local max_wait=60
    local count=0
    
    while [[ $count -lt $max_wait ]]; do
        if systemctl is-active --quiet opennms; then
            log_info "OpenNMS is running"
            break
        fi
        sleep 2
        ((count+=2))
    done
    
    if [[ $count -ge $max_wait ]]; then
        log_warn "OpenNMS took longer than expected to start"
    fi
    
    # Check if web interface is accessible
    sleep 10
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8980/opennms/ | grep -q "200"; then
        log_info "OpenNMS web interface is accessible"
    else
        log_warn "OpenNMS web interface may not be ready yet. Give it a few more minutes."
    fi
}

print_summary() {
    log_info "======================================"
    log_info "OpenNMS Installation Complete!"
    log_info "======================================"
    log_info ""
    log_info "Access OpenNMS at: http://localhost:8980/opennms"
    log_info "Default credentials: admin / admin"
    log_info ""
    log_info "Important next steps:"
    log_info "1. Change the default admin password"
    log_info "2. Configure network discovery"
    log_info "3. Set up notification policies"
    log_info "4. Review firewall settings"
    log_info ""
    log_info "Documentation: https://docs.opennms.com/"
    log_info "Log file: $LOG_FILE"
    log_info "======================================"
}

################################################################################
# Main Execution
################################################################################

main() {
    log_info "Starting OpenNMS installation..."
    
    check_root
    check_system
    install_dependencies
    setup_postgresql
    install_opennms
    configure_opennms
    start_opennms
    verify_installation
    print_summary
    
    log_info "Installation completed successfully!"
}

# Trap errors
trap 'log_error "Installation failed at line $LINENO"' ERR

# Run main function
main "$@"
