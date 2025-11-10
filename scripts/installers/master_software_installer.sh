#!/bin/bash

################################################################################
# Master Software Installer
# 
# Description: Interactive installer for all CloudCurio software packages
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
# 
# Features:
#   - Interactive menu system
#   - Category-based installation
#   - Individual software selection
#   - Progress tracking
#   - Error handling and logging
#
# Usage: sudo bash master_software_installer.sh
################################################################################

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/tmp/master_installer_$(date +%Y%m%d_%H%M%S).log"
readonly INSTALL_LOG_DIR="/var/log/cloudcurio-installs"

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

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

print_header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║          CloudCurio Master Software Installer              ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║  Comprehensive installation for 60+ DevOps tools           ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_menu() {
    local title="$1"
    shift
    local options=("$@")
    
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}  $title${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    for i in "${!options[@]}"; do
        echo -e "  ${BLUE}$((i+1)).${NC} ${options[$i]}"
    done
    echo ""
    echo -e "  ${BLUE}0.${NC} Back/Exit"
    echo ""
}

get_user_choice() {
    local max_option=$1
    local choice
    
    while true; do
        read -p "$(echo -e ${YELLOW}"Enter your choice [0-$max_option]: "${NC})" choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 0 ]] && [[ "$choice" -le "$max_option" ]]; then
            echo "$choice"
            return
        else
            log_error "Invalid choice. Please enter a number between 0 and $max_option"
        fi
    done
}

confirm_action() {
    local message="$1"
    local response
    
    read -p "$(echo -e ${YELLOW}"$message (y/n): "${NC})" response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

run_installer() {
    local installer_path="$1"
    local software_name="$2"
    
    log_info "Installing $software_name..."
    
    if [[ ! -f "$installer_path" ]]; then
        log_error "Installer not found: $installer_path"
        return 1
    fi
    
    chmod +x "$installer_path"
    
    if bash "$installer_path"; then
        log_success "$software_name installed successfully!"
        return 0
    else
        log_error "Failed to install $software_name"
        return 1
    fi
}

################################################################################
# Installation Categories
################################################################################

monitoring_tools_menu() {
    while true; do
        print_header
        print_menu "Monitoring & Network Tools" \
            "OpenNMS (Enterprise network monitoring)" \
            "Zabbix (Complete monitoring solution)" \
            "Web Check (Website availability monitoring)" \
            "Install All Monitoring Tools"
        
        choice=$(get_user_choice 4)
        
        case $choice in
            0) return ;;
            1) run_installer "$SCRIPT_DIR/monitoring/install_opennms.sh" "OpenNMS" ;;
            2) run_installer "$SCRIPT_DIR/monitoring/install_zabbix.sh" "Zabbix" ;;
            3) log_warn "Web Check is Docker-only. Use: docker-compose -f docker/compose/monitoring/webcheck.yml up -d" ;;
            4)
                if confirm_action "Install all monitoring tools?"; then
                    run_installer "$SCRIPT_DIR/monitoring/install_opennms.sh" "OpenNMS"
                    run_installer "$SCRIPT_DIR/monitoring/install_zabbix.sh" "Zabbix"
                fi
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

automation_tools_menu() {
    while true; do
        print_header
        print_menu "Automation Platforms" \
            "Leon (Open-source personal assistant)" \
            "Automatisch (Workflow automation)" \
            "StackStorm (Event-driven automation)" \
            "Eonza (Task automation)" \
            "Kibitzr (Web monitoring automation)" \
            "Install All Automation Tools"
        
        choice=$(get_user_choice 6)
        
        case $choice in
            0) return ;;
            1) run_installer "$SCRIPT_DIR/automation/install_leon.sh" "Leon" ;;
            2) run_installer "$SCRIPT_DIR/automation/install_automatisch.sh" "Automatisch" ;;
            3) log_warn "StackStorm recommended via Docker. Use: docker-compose -f docker/compose/automation/stackstorm.yml up -d" ;;
            4) run_installer "$SCRIPT_DIR/automation/install_eonza.sh" "Eonza" ;;
            5) run_installer "$SCRIPT_DIR/automation/install_kibitzr.sh" "Kibitzr" ;;
            6)
                if confirm_action "Install all automation tools?"; then
                    run_installer "$SCRIPT_DIR/automation/install_leon.sh" "Leon"
                    run_installer "$SCRIPT_DIR/automation/install_automatisch.sh" "Automatisch"
                    run_installer "$SCRIPT_DIR/automation/install_eonza.sh" "Eonza"
                    run_installer "$SCRIPT_DIR/automation/install_kibitzr.sh" "Kibitzr"
                fi
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

analytics_tools_menu() {
    while true; do
        print_header
        print_menu "Analytics & Business Intelligence" \
            "Metabase (Business intelligence)" \
            "Apache Superset (Data visualization)" \
            "PostHog (Product analytics)" \
            "Plausible (Privacy-friendly analytics)" \
            "Umami (Simple analytics)" \
            "Aptabase (Mobile/desktop analytics)" \
            "Mixpost (Social media management)" \
            "Open Web Analytics" \
            "Install All Analytics Tools"
        
        choice=$(get_user_choice 9)
        
        case $choice in
            0) return ;;
            1) run_installer "$SCRIPT_DIR/analytics/install_metabase.sh" "Metabase" ;;
            2) run_installer "$SCRIPT_DIR/analytics/install_superset.sh" "Apache Superset" ;;
            3) log_info "PostHog recommended via Docker. Use: docker-compose -f docker/compose/analytics/posthog.yml up -d" ;;
            4) log_info "Plausible recommended via Docker. Use: docker-compose -f docker/compose/analytics/plausible.yml up -d" ;;
            5) log_info "Umami recommended via Docker. Use: docker-compose -f docker/compose/analytics/umami.yml up -d" ;;
            6) log_info "Aptabase recommended via Docker. Use: docker-compose -f docker/compose/analytics/aptabase.yml up -d" ;;
            7) log_info "Mixpost recommended via Docker. Use: docker-compose -f docker/compose/analytics/mixpost.yml up -d" ;;
            8) run_installer "$SCRIPT_DIR/analytics/install_owa.sh" "Open Web Analytics" ;;
            9)
                if confirm_action "Install all analytics tools (bare metal only)?"; then
                    run_installer "$SCRIPT_DIR/analytics/install_metabase.sh" "Metabase"
                    run_installer "$SCRIPT_DIR/analytics/install_superset.sh" "Apache Superset"
                    run_installer "$SCRIPT_DIR/analytics/install_owa.sh" "Open Web Analytics"
                fi
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

data_infrastructure_menu() {
    while true; do
        print_header
        print_menu "Data Infrastructure" \
            "Apache Kafka (Event streaming)" \
            "Apache Cassandra (NoSQL database)" \
            "RudderStack (Customer data platform)" \
            "Parseable (Log analytics)" \
            "Install All Data Tools"
        
        choice=$(get_user_choice 5)
        
        case $choice in
            0) return ;;
            1) run_installer "$SCRIPT_DIR/data/install_kafka.sh" "Apache Kafka" ;;
            2) run_installer "$SCRIPT_DIR/data/install_cassandra.sh" "Apache Cassandra" ;;
            3) log_info "RudderStack recommended via Docker. Use: docker-compose -f docker/compose/data/rudderstack.yml up -d" ;;
            4) run_installer "$SCRIPT_DIR/data/install_parseable.sh" "Parseable" ;;
            5)
                if confirm_action "Install all data infrastructure tools?"; then
                    run_installer "$SCRIPT_DIR/data/install_kafka.sh" "Apache Kafka"
                    run_installer "$SCRIPT_DIR/data/install_cassandra.sh" "Apache Cassandra"
                    run_installer "$SCRIPT_DIR/data/install_parseable.sh" "Parseable"
                fi
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

cms_frameworks_menu() {
    while true; do
        print_header
        print_menu "CMS & Web Frameworks" \
            "WordPress (CMS)" \
            "Ghost (Headless CMS)" \
            "Hugo (Static site generator)" \
            "Next.js (React framework)" \
            "Astro (Static site builder)" \
            "Install All CMS/Framework Tools"
        
        choice=$(get_user_choice 6)
        
        case $choice in
            0) return ;;
            1) log_info "WordPress recommended via Docker. Use: docker-compose -f docker/compose/cms/wordpress.yml up -d" ;;
            2) log_info "Ghost recommended via Docker. Use: docker-compose -f docker/compose/cms/ghost.yml up -d" ;;
            3) run_installer "$SCRIPT_DIR/cms/install_hugo.sh" "Hugo" ;;
            4) run_installer "$SCRIPT_DIR/frameworks/install_nextjs.sh" "Next.js" ;;
            5) run_installer "$SCRIPT_DIR/frameworks/install_astro.sh" "Astro" ;;
            6)
                if confirm_action "Install all CMS/Framework tools (bare metal only)?"; then
                    run_installer "$SCRIPT_DIR/cms/install_hugo.sh" "Hugo"
                    run_installer "$SCRIPT_DIR/frameworks/install_nextjs.sh" "Next.js"
                    run_installer "$SCRIPT_DIR/frameworks/install_astro.sh" "Astro"
                fi
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

development_tools_menu() {
    while true; do
        print_header
        print_menu "Development Tools & AI Assistants" \
            "TypeScript LSP" \
            "Python LSP" \
            "Codex CLI" \
            "Gemini CLI" \
            "Cline (AI coding assistant)" \
            "Kimi CLI" \
            "Crush (Terminal code assistant)" \
            "OliveTin (Web UI for shell commands)" \
            "Install All Development Tools"
        
        choice=$(get_user_choice 9)
        
        case $choice in
            0) return ;;
            1) run_installer "$SCRIPT_DIR/development/install_typescript_lsp.sh" "TypeScript LSP" ;;
            2) run_installer "$SCRIPT_DIR/development/install_python_lsp.sh" "Python LSP" ;;
            3) run_installer "$SCRIPT_DIR/ai-tools/install_codex_cli.sh" "Codex CLI" ;;
            4) run_installer "$SCRIPT_DIR/ai-tools/install_gemini_cli.sh" "Gemini CLI" ;;
            5) run_installer "$SCRIPT_DIR/ai-tools/install_cline.sh" "Cline" ;;
            6) run_installer "$SCRIPT_DIR/ai-tools/install_kimi_cli.sh" "Kimi CLI" ;;
            7) run_installer "$SCRIPT_DIR/ai-tools/install_crush.sh" "Crush" ;;
            8) run_installer "$SCRIPT_DIR/system/install_olivetin.sh" "OliveTin" ;;
            9)
                if confirm_action "Install all development tools?"; then
                    run_installer "$SCRIPT_DIR/development/install_typescript_lsp.sh" "TypeScript LSP"
                    run_installer "$SCRIPT_DIR/development/install_python_lsp.sh" "Python LSP"
                    run_installer "$SCRIPT_DIR/ai-tools/install_gemini_cli.sh" "Gemini CLI"
                    run_installer "$SCRIPT_DIR/ai-tools/install_cline.sh" "Cline"
                    run_installer "$SCRIPT_DIR/system/install_olivetin.sh" "OliveTin"
                fi
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

gaming_tools_menu() {
    while true; do
        print_header
        print_menu "Gaming & Entertainment" \
            "LinuxGSM (Game server manager)" \
            "Matchering (AI audio mastering)"
        
        choice=$(get_user_choice 2)
        
        case $choice in
            0) return ;;
            1) run_installer "$SCRIPT_DIR/gaming/install_linuxgsm.sh" "LinuxGSM" ;;
            2) run_installer "$SCRIPT_DIR/ai-ml/install_matchering.sh" "Matchering" ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

dashboard_tools_menu() {
    while true; do
        print_header
        print_menu "Dashboards & Homepage" \
            "Homepage (Application dashboard)"
        
        choice=$(get_user_choice 1)
        
        case $choice in
            0) return ;;
            1) log_info "Homepage recommended via Docker. Use: docker-compose -f docker/compose/dashboard/homepage.yml up -d" ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

################################################################################
# Main Menu
################################################################################

main_menu() {
    while true; do
        print_header
        print_menu "Main Menu - Select Category" \
            "Monitoring & Network Tools" \
            "Automation Platforms" \
            "Analytics & Business Intelligence" \
            "Data Infrastructure (Kafka, Cassandra, etc.)" \
            "CMS & Web Frameworks" \
            "Development Tools & AI Assistants" \
            "Gaming & Entertainment" \
            "Dashboards & Homepage" \
            "View Software Catalog" \
            "View Installation Logs"
        
        choice=$(get_user_choice 10)
        
        case $choice in
            0)
                log_info "Exiting installer. Thank you!"
                exit 0
                ;;
            1) monitoring_tools_menu ;;
            2) automation_tools_menu ;;
            3) analytics_tools_menu ;;
            4) data_infrastructure_menu ;;
            5) cms_frameworks_menu ;;
            6) development_tools_menu ;;
            7) gaming_tools_menu ;;
            8) dashboard_tools_menu ;;
            9)
                if [[ -f "$SCRIPT_DIR/../../SOFTWARE_CATALOG.md" ]]; then
                    less "$SCRIPT_DIR/../../SOFTWARE_CATALOG.md"
                else
                    log_error "Software catalog not found"
                fi
                ;;
            10)
                log_info "Recent installation logs:"
                ls -lht /tmp/*_install_*.log 2>/dev/null | head -10 || log_warn "No logs found"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

################################################################################
# Initialization
################################################################################

initialize() {
    log_info "Initializing CloudCurio Master Installer..."
    
    # Create log directory
    mkdir -p "$INSTALL_LOG_DIR"
    
    # Check system
    check_root
    
    log_info "Initialization complete"
}

################################################################################
# Main Execution
################################################################################

main() {
    initialize
    main_menu
}

# Trap errors
trap 'log_error "Installation failed at line $LINENO"' ERR

# Run main function
main "$@"
