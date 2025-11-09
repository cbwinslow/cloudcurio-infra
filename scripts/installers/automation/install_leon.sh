#!/bin/bash

################################################################################
# Leon AI Assistant Installation Script
# 
# Description: Installs Leon - Open-source personal assistant
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
# 
# Features:
#   - Voice command support
#   - Privacy-focused (runs locally)
#   - Modular architecture
#   - Multi-language support
#
# Requirements:
#   - Ubuntu/Debian-based system
#   - Node.js 18+
#   - Python 3.8+
#   - 2GB+ RAM
#
# Usage: sudo bash install_leon.sh
################################################################################

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Configuration
readonly LEON_DIR="/opt/leon"
readonly LEON_USER="leon"
readonly LOG_FILE="/tmp/leon_install_$(date +%Y%m%d_%H%M%S).log"

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

install_nodejs() {
    log_info "Installing Node.js 18..."
    
    # Check if Node.js is already installed
    if command -v node &> /dev/null; then
        local node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [[ $node_version -ge 18 ]]; then
            log_info "Node.js $node_version is already installed"
            return
        fi
    fi
    
    # Install Node.js
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - || {
        log_error "Failed to add Node.js repository"
        exit 1
    }
    
    apt-get install -y nodejs || {
        log_error "Failed to install Node.js"
        exit 1
    }
    
    log_info "Node.js installed successfully"
}

install_python() {
    log_info "Installing Python dependencies..."
    
    apt-get install -y \
        python3 \
        python3-pip \
        python3-dev \
        build-essential || {
        log_error "Failed to install Python"
        exit 1
    }
    
    log_info "Python installed successfully"
}

install_system_dependencies() {
    log_info "Installing system dependencies..."
    
    apt-get update || {
        log_error "Failed to update package list"
        exit 1
    }
    
    apt-get install -y \
        git \
        curl \
        wget \
        sox \
        ffmpeg \
        flac \
        libsox-fmt-mp3 \
        portaudio19-dev || {
        log_error "Failed to install system dependencies"
        exit 1
    }
    
    log_info "System dependencies installed successfully"
}

create_leon_user() {
    log_info "Creating Leon user..."
    
    if ! id "$LEON_USER" &>/dev/null; then
        useradd -r -m -d "$LEON_DIR" -s /bin/bash "$LEON_USER" || {
            log_error "Failed to create Leon user"
            exit 1
        }
        log_info "Leon user created"
    else
        log_info "Leon user already exists"
    fi
}

install_leon() {
    log_info "Installing Leon AI Assistant..."
    
    # Clone Leon repository
    if [[ ! -d "$LEON_DIR/leon" ]]; then
        sudo -u "$LEON_USER" git clone https://github.com/leon-ai/leon.git "$LEON_DIR/leon" || {
            log_error "Failed to clone Leon repository"
            exit 1
        }
    else
        log_info "Leon repository already exists"
    fi
    
    cd "$LEON_DIR/leon"
    
    # Install dependencies
    log_info "Installing Leon dependencies (this may take a while)..."
    sudo -u "$LEON_USER" npm install || {
        log_error "Failed to install Leon dependencies"
        exit 1
    }
    
    # Set up configuration
    if [[ ! -f .env ]]; then
        sudo -u "$LEON_USER" cp .env.sample .env || {
            log_error "Failed to create configuration file"
            exit 1
        }
    fi
    
    log_info "Leon installed successfully"
}

setup_python_packages() {
    log_info "Setting up Python packages..."
    
    cd "$LEON_DIR/leon"
    
    # Create Python virtual environment
    sudo -u "$LEON_USER" python3 -m pip install --user pipenv || {
        log_error "Failed to install pipenv"
        exit 1
    }
    
    # Install Python dependencies
    sudo -u "$LEON_USER" npm run setup:offline-stt || log_warn "Offline STT setup failed, continuing..."
    sudo -u "$LEON_USER" npm run setup:offline-tts || log_warn "Offline TTS setup failed, continuing..."
    
    log_info "Python packages setup completed"
}

build_leon() {
    log_info "Building Leon..."
    
    cd "$LEON_DIR/leon"
    
    sudo -u "$LEON_USER" npm run build || {
        log_error "Failed to build Leon"
        exit 1
    }
    
    log_info "Leon built successfully"
}

create_systemd_service() {
    log_info "Creating systemd service..."
    
    cat > /etc/systemd/system/leon.service <<EOF
[Unit]
Description=Leon AI Personal Assistant
After=network.target

[Service]
Type=simple
User=$LEON_USER
WorkingDirectory=$LEON_DIR/leon
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload || {
        log_error "Failed to reload systemd"
        exit 1
    }
    
    log_info "Systemd service created"
}

start_leon() {
    log_info "Starting Leon service..."
    
    systemctl enable leon || {
        log_error "Failed to enable Leon service"
        exit 1
    }
    
    systemctl start leon || {
        log_error "Failed to start Leon service"
        exit 1
    }
    
    log_info "Leon service started"
}

verify_installation() {
    log_info "Verifying installation..."
    
    sleep 10
    
    if systemctl is-active --quiet leon; then
        log_info "Leon service is running"
    else
        log_warn "Leon service may not be running properly"
    fi
    
    # Check if web interface is accessible
    local max_attempts=10
    local attempt=0
    
    while [[ $attempt -lt $max_attempts ]]; do
        if curl -s -o /dev/null -w "%{http_code}" http://localhost:1337 | grep -q "200\|302"; then
            log_info "Leon web interface is accessible"
            return
        fi
        sleep 3
        ((attempt++))
    done
    
    log_warn "Leon web interface may not be ready yet. Check logs: journalctl -u leon"
}

print_summary() {
    log_info "======================================"
    log_info "Leon AI Assistant Installation Complete!"
    log_info "======================================"
    log_info ""
    log_info "Access Leon at: http://localhost:1337"
    log_info ""
    log_info "Leon installation directory: $LEON_DIR/leon"
    log_info "Configuration file: $LEON_DIR/leon/.env"
    log_info ""
    log_info "Useful commands:"
    log_info "  Start Leon: sudo systemctl start leon"
    log_info "  Stop Leon: sudo systemctl stop leon"
    log_info "  View logs: sudo journalctl -u leon -f"
    log_info ""
    log_info "Next steps:"
    log_info "1. Edit $LEON_DIR/leon/.env to configure Leon"
    log_info "2. Set up voice recognition (optional)"
    log_info "3. Configure skills and modules"
    log_info "4. Test voice commands"
    log_info ""
    log_info "Documentation: https://docs.getleon.ai/"
    log_info "Log file: $LOG_FILE"
    log_info "======================================"
}

################################################################################
# Main Execution
################################################################################

main() {
    log_info "Starting Leon AI Assistant installation..."
    
    check_root
    install_system_dependencies
    install_nodejs
    install_python
    create_leon_user
    install_leon
    setup_python_packages
    build_leon
    create_systemd_service
    start_leon
    verify_installation
    print_summary
    
    log_info "Installation completed successfully!"
}

# Trap errors
trap 'log_error "Installation failed at line $LINENO"' ERR

# Run main function
main "$@"
