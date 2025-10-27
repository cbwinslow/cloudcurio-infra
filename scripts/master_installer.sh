#!/bin/bash
# Master installer script for CloudCurio Infrastructure
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================================"
echo "CloudCurio Infrastructure - Master Installer"
echo "================================================"
echo ""
echo "This script will help you install various infrastructure components."
echo ""
echo "Available installation options:"
echo "1)  ZeroTier (Mesh VPN)"
echo "2)  Docker & Docker Compose"
echo "3)  Monitoring Stack (Prometheus, Grafana, Loki)"
echo "4)  Security Stack (Suricata, Wazuh, fail2ban)"
echo "5)  AI/ML Stack (AnythingLLM, LocalAI, Langfuse, Qdrant)"
echo "6)  Web Servers (Apache, Nginx, Caddy)"
echo "7)  Automation Tools (SaltStack)"
echo "8)  Infrastructure Tools (Chezmoi, Teleport, common utilities)"
echo "9)  AI Coding Tools (Aider, Cline, Cursor, GitHub Copilot, etc.)"
echo "10) Full Stack (Install everything)"
echo "11) Custom Selection"
echo "12) Validate Installations"
echo "13) Uninstall Components"
echo "0)  Exit"
echo ""

read -p "Choose an option [0-13]: " choice

case $choice in
    1)
        echo "Installing ZeroTier..."
        bash "$SCRIPT_DIR/installers/networking/install_zerotier.sh"
        ;;
    2)
        echo "Installing Docker..."
        bash "$SCRIPT_DIR/installers/container/install_docker.sh"
        ;;
    3)
        echo "Installing Monitoring Stack..."
        bash "$SCRIPT_DIR/installers/monitoring/install_monitoring_stack.sh"
        ;;
    4)
        echo "Installing Security Stack..."
        bash "$SCRIPT_DIR/installers/security/install_security_stack.sh"
        ;;
    5)
        echo "Installing AI/ML Stack..."
        bash "$SCRIPT_DIR/installers/ai-ml/install_ai_stack.sh"
        ;;
    6)
        echo "Installing Web Servers..."
        bash "$SCRIPT_DIR/installers/web/install_webservers.sh"
        ;;
    7)
        echo "Installing Automation Tools..."
        bash "$SCRIPT_DIR/installers/automation/install_saltstack.sh"
        ;;
    8)
        echo "Installing Infrastructure Tools..."
        bash "$SCRIPT_DIR/installers/infrastructure/install_common_tools.sh"
        ;;
    9)
        echo "Installing AI Coding Tools..."
        bash "$SCRIPT_DIR/installers/development/install_ai_coding_tools.sh"
        ;;
    10)
        echo "Installing Full Stack..."
        echo "This will take some time..."
        
        bash "$SCRIPT_DIR/installers/infrastructure/install_common_tools.sh"
        bash "$SCRIPT_DIR/installers/networking/install_zerotier.sh"
        bash "$SCRIPT_DIR/installers/container/install_docker.sh"
        bash "$SCRIPT_DIR/installers/monitoring/install_monitoring_stack.sh"
        bash "$SCRIPT_DIR/installers/security/install_security_stack.sh"
        bash "$SCRIPT_DIR/installers/ai-ml/install_ai_stack.sh"
        bash "$SCRIPT_DIR/installers/automation/install_saltstack.sh"
        bash "$SCRIPT_DIR/installers/development/install_ai_coding_tools.sh"
        
        echo ""
        echo "Full stack installation complete!"
        ;;
    11)
        echo "Custom Selection..."
        echo "Select components to install (space-separated numbers, e.g., 1 2 3):"
        echo "1) ZeroTier  2) Docker  3) Monitoring  4) Security  5) AI/ML  6) Web  7) Automation  8) Infrastructure  9) AI Coding Tools"
        read -p "Enter selections: " selections
        
        for sel in $selections; do
            case $sel in
                1) bash "$SCRIPT_DIR/installers/networking/install_zerotier.sh" ;;
                2) bash "$SCRIPT_DIR/installers/container/install_docker.sh" ;;
                3) bash "$SCRIPT_DIR/installers/monitoring/install_monitoring_stack.sh" ;;
                4) bash "$SCRIPT_DIR/installers/security/install_security_stack.sh" ;;
                5) bash "$SCRIPT_DIR/installers/ai-ml/install_ai_stack.sh" ;;
                6) bash "$SCRIPT_DIR/installers/web/install_webservers.sh" ;;
                7) bash "$SCRIPT_DIR/installers/automation/install_saltstack.sh" ;;
                8) bash "$SCRIPT_DIR/installers/infrastructure/install_common_tools.sh" ;;
                9) bash "$SCRIPT_DIR/installers/development/install_ai_coding_tools.sh" ;;
                *) echo "Invalid selection: $sel" ;;
            esac
        done
        ;;
    12)
        echo "Validating installations..."
        bash "$SCRIPT_DIR/validators/validate_all_components.sh"
        ;;
    13)
        echo "Opening uninstaller..."
        bash "$SCRIPT_DIR/master_uninstaller.sh"
        ;;
    0)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "================================================"
echo "Installation Complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. Validate installation: bash scripts/validators/validate_all_components.sh"
echo "2. Configure your newly installed services"
echo "3. Review the documentation in INFRASTRUCTURE_GUIDE.md"
echo "4. Run Ansible playbooks for automated configuration"
echo ""
echo "For Ansible automation, use:"
echo "  ansible-playbook -i inventory/hosts.ini playbooks/master_infrastructure_setup.yml"
echo ""
