#!/bin/bash
###############################################################################
# CloudCurio Infrastructure - Installation Wizard
#
# This interactive wizard guides users through the installation process,
# helping them select and install tools based on their needs.
#
# Usage:
#   ./scripts/install-wizard.sh
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Clear screen function
clear_screen() {
    clear
    echo -e "${CYAN}=========================================="
    echo "CloudCurio Infrastructure"
    echo "Installation Wizard"
    echo -e "==========================================${NC}"
    echo ""
}

# Print menu
print_menu() {
    local title=$1
    shift
    local options=("$@")
    
    echo -e "${BLUE}$title${NC}"
    echo ""
    
    for i in "${!options[@]}"; do
        echo "  $((i+1)). ${options[$i]}"
    done
    echo ""
}

# Get user choice
get_choice() {
    local prompt=$1
    local max=$2
    local choice
    
    while true; do
        read -p "$prompt" choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$max" ]; then
            echo $choice
            return
        else
            echo -e "${RED}Invalid choice. Please enter a number between 1 and $max${NC}"
        fi
    done
}

# Confirm action
confirm() {
    local prompt=$1
    local response
    
    read -p "$prompt (y/n): " response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Main wizard
clear_screen

echo "Welcome to the CloudCurio Infrastructure Installation Wizard!"
echo ""
echo "This wizard will help you install DevOps tools on your system."
echo "You can install pre-configured stacks or select individual tools."
echo ""

read -p "Press Enter to continue..."

# Step 1: Choose installation type
clear_screen
print_menu "What would you like to install?" \
    "Pre-configured Stack (Recommended for beginners)" \
    "Individual Tools (Advanced)" \
    "Everything (Full installation)" \
    "Exit"

install_type=$(get_choice "Enter your choice: " 4)

case $install_type in
    1)
        # Pre-configured stacks
        clear_screen
        print_menu "Choose a pre-configured stack:" \
            "Development Workstation (Python, Node.js, Docker, Git, VS Code)" \
            "AI/ML Environment (Python, Docker, Ollama, LocalAI, OpenWebUI)" \
            "Monitoring Stack (Prometheus, Grafana, Loki, Elasticsearch)" \
            "Web Development (Node.js, PHP, MySQL, Nginx)" \
            "Database Server (PostgreSQL, MySQL, Redis, ClickHouse)" \
            "Back to main menu"
        
        stack_choice=$(get_choice "Enter your choice: " 6)
        
        case $stack_choice in
            1)
                TAGS="python,nodejs,docker,git,vscode"
                DESCRIPTION="Development Workstation"
                ;;
            2)
                TAGS="python,docker,ollama,localai,openwebui,flowise"
                DESCRIPTION="AI/ML Environment"
                ;;
            3)
                TAGS="prometheus,grafana,loki,elasticsearch"
                DESCRIPTION="Monitoring Stack"
                ;;
            4)
                TAGS="nodejs,php,mysql,nginx"
                DESCRIPTION="Web Development Stack"
                ;;
            5)
                TAGS="postgresql,mysql,clickhouse,influxdb"
                DESCRIPTION="Database Server"
                ;;
            6)
                exec $0
                ;;
        esac
        ;;
    
    2)
        # Individual tools
        clear_screen
        echo "Individual tool selection is available through:"
        echo "  1. The TUI: python3 tui/installer.py"
        echo "  2. Ansible tags: ansible-playbook -i inventory/hosts.ini sites.yml --tags 'tool1,tool2'"
        echo ""
        echo "Available categories:"
        echo "  - python, nodejs, php (Programming languages)"
        echo "  - docker, podman (Containers)"
        echo "  - postgresql, mysql, mongodb (Databases)"
        echo "  - nginx, apache2, caddy (Web servers)"
        echo "  - grafana, prometheus (Monitoring)"
        echo "  - And many more..."
        echo ""
        read -p "Press Enter to exit wizard and use advanced methods..."
        exit 0
        ;;
    
    3)
        # Everything
        TAGS=""
        DESCRIPTION="Full Installation (All Tools)"
        ;;
    
    4)
        echo "Exiting wizard..."
        exit 0
        ;;
esac

# Step 2: Confirm installation
clear_screen
echo -e "${GREEN}Ready to install: $DESCRIPTION${NC}"
echo ""

if [ -n "$TAGS" ]; then
    echo "This will install the following tools:"
    echo "  Tags: $TAGS"
else
    echo "This will install ALL available tools."
fi

echo ""
echo "Installation command:"
if [ -n "$TAGS" ]; then
    echo "  ansible-playbook -i inventory/hosts.ini sites.yml --tags '$TAGS'"
else
    echo "  ansible-playbook -i inventory/hosts.ini sites.yml"
fi
echo ""

if ! confirm "Do you want to proceed with the installation?"; then
    echo "Installation cancelled."
    exit 0
fi

# Step 3: Check requirements
echo ""
echo "Checking system requirements..."
if [ -f scripts/check-requirements.sh ]; then
    bash scripts/check-requirements.sh
    if [ $? -ne 0 ]; then
        echo ""
        if ! confirm "Requirements check failed. Continue anyway?"; then
            echo "Installation cancelled."
            exit 1
        fi
    fi
fi

# Step 4: Run installation
echo ""
echo -e "${GREEN}Starting installation...${NC}"
echo ""

if [ -n "$TAGS" ]; then
    ansible-playbook -i inventory/hosts.ini sites.yml --tags "$TAGS"
else
    ansible-playbook -i inventory/hosts.ini sites.yml
fi

# Step 5: Verify installation
echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""

if confirm "Would you like to verify the installation?"; then
    if [ -f scripts/verify-installation.sh ]; then
        bash scripts/verify-installation.sh
    else
        echo "Verification script not found."
    fi
fi

echo ""
echo -e "${GREEN}Thank you for using CloudCurio Infrastructure!${NC}"
echo ""
echo "Next steps:"
echo "  - Check service status: sudo systemctl status <service>"
echo "  - View installed tools: ./scripts/list-installed.sh"
echo "  - Read documentation: cat README.md"
echo ""
