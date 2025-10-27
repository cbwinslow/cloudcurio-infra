#!/bin/bash
# Master uninstaller script for CloudCurio Infrastructure
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "================================================"
echo "CloudCurio Infrastructure - Master Uninstaller"
echo "================================================"
echo ""
echo -e "${RED}WARNING: This will remove installed components!${NC}"
echo ""
echo "Available uninstallation options:"
echo "1)  ZeroTier (Mesh VPN)"
echo "2)  Docker & Docker Compose"
echo "3)  Monitoring Stack (Prometheus, Grafana, Loki)"
echo "4)  Security Stack (Suricata, Wazuh, fail2ban)"
echo "5)  All Components (Complete uninstall)"
echo "0)  Exit"
echo ""

read -p "Choose an option [0-5]: " choice

case $choice in
    1)
        echo "Uninstalling ZeroTier..."
        bash "$SCRIPT_DIR/uninstallers/networking/uninstall_zerotier.sh"
        ;;
    2)
        echo "Uninstalling Docker..."
        bash "$SCRIPT_DIR/uninstallers/container/uninstall_docker.sh"
        ;;
    3)
        echo "Uninstalling Monitoring Stack..."
        bash "$SCRIPT_DIR/uninstallers/monitoring/uninstall_monitoring_stack.sh"
        ;;
    4)
        echo "Uninstalling Security Stack..."
        bash "$SCRIPT_DIR/uninstallers/security/uninstall_security_stack.sh"
        ;;
    5)
        echo -e "${YELLOW}This will remove ALL installed components!${NC}"
        read -p "Are you absolutely sure? (yes/NO): " confirm
        if [ "$confirm" = "yes" ]; then
            echo "Uninstalling all components..."
            
            bash "$SCRIPT_DIR/uninstallers/security/uninstall_security_stack.sh" || true
            bash "$SCRIPT_DIR/uninstallers/monitoring/uninstall_monitoring_stack.sh" || true
            bash "$SCRIPT_DIR/uninstallers/container/uninstall_docker.sh" || true
            bash "$SCRIPT_DIR/uninstallers/networking/uninstall_zerotier.sh" || true
            
            echo ""
            echo "All components uninstalled!"
        else
            echo "Uninstallation cancelled."
        fi
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
echo "Uninstallation Complete!"
echo "================================================"
echo ""
