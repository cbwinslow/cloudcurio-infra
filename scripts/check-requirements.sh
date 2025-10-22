#!/bin/bash
###############################################################################
# CloudCurio Infrastructure - System Requirements Checker
#
# This script validates that the system meets all prerequisites for running
# the CloudCurio Infrastructure installer.
#
# Checks performed:
# - Operating system compatibility
# - Python version
# - Ansible installation
# - Disk space
# - Memory
# - Network connectivity
# - Required system packages
#
# Usage:
#   ./scripts/check-requirements.sh
#
# Exit codes:
#   0 - All requirements met
#   1 - One or more requirements not met
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    
    case $status in
        "PASS")
            echo -e "${GREEN}✓${NC} $message"
            ((PASSED++))
            ;;
        "FAIL")
            echo -e "${RED}✗${NC} $message"
            ((FAILED++))
            ;;
        "WARN")
            echo -e "${YELLOW}!${NC} $message"
            ((WARNINGS++))
            ;;
        "INFO")
            echo -e "${BLUE}ℹ${NC} $message"
            ;;
    esac
}

# Print header
echo "=========================================="
echo "CloudCurio Infrastructure"
echo "System Requirements Checker"
echo "=========================================="
echo ""

# Check 1: Operating System
print_status "INFO" "Checking operating system..."
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "  OS: $NAME $VERSION"
    
    case $ID in
        ubuntu)
            if [[ "${VERSION_ID}" == "20.04" ]] || [[ "${VERSION_ID}" == "22.04" ]] || [[ "${VERSION_ID}" == "24.04" ]]; then
                print_status "PASS" "Ubuntu version $VERSION_ID is supported"
            else
                print_status "WARN" "Ubuntu version $VERSION_ID may not be fully supported"
            fi
            ;;
        debian)
            print_status "PASS" "Debian-based system detected"
            ;;
        *)
            print_status "WARN" "OS $ID may not be fully supported"
            ;;
    esac
else
    print_status "FAIL" "Could not determine operating system"
fi
echo ""

# Check 2: Python
print_status "INFO" "Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    echo "  Python version: $PYTHON_VERSION"
    
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d'.' -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d'.' -f2)
    
    if [[ $PYTHON_MAJOR -ge 3 ]] && [[ $PYTHON_MINOR -ge 8 ]]; then
        print_status "PASS" "Python 3.$PYTHON_MINOR meets requirements (>= 3.8)"
    else
        print_status "FAIL" "Python 3.8 or higher required"
    fi
else
    print_status "FAIL" "Python 3 not found"
fi
echo ""

# Check 3: pip
print_status "INFO" "Checking pip installation..."
if command -v pip3 &> /dev/null; then
    PIP_VERSION=$(pip3 --version | cut -d' ' -f2)
    echo "  pip version: $PIP_VERSION"
    print_status "PASS" "pip3 is installed"
else
    print_status "FAIL" "pip3 not found"
fi
echo ""

# Check 4: Ansible
print_status "INFO" "Checking Ansible installation..."
if command -v ansible &> /dev/null; then
    ANSIBLE_VERSION=$(ansible --version | head -n1 | cut -d' ' -f2 | tr -d ']')
    echo "  Ansible version: $ANSIBLE_VERSION"
    print_status "PASS" "Ansible is installed"
else
    print_status "WARN" "Ansible not found (can be installed with: pip3 install ansible)"
fi
echo ""

# Check 5: Disk Space
print_status "INFO" "Checking disk space..."
AVAILABLE_SPACE=$(df -BG / | tail -1 | awk '{print $4}' | tr -d 'G')
echo "  Available space: ${AVAILABLE_SPACE}GB"

if [[ $AVAILABLE_SPACE -ge 10 ]]; then
    print_status "PASS" "Sufficient disk space available (>= 10GB)"
else
    print_status "WARN" "Low disk space. Recommended: 10GB, Available: ${AVAILABLE_SPACE}GB"
fi
echo ""

# Check 6: Memory
print_status "INFO" "Checking memory..."
TOTAL_MEM=$(free -g | awk '/^Mem:/ {print $2}')
echo "  Total memory: ${TOTAL_MEM}GB"

if [[ $TOTAL_MEM -ge 4 ]]; then
    print_status "PASS" "Sufficient memory (>= 4GB)"
else
    print_status "WARN" "Low memory. Recommended: 4GB, Available: ${TOTAL_MEM}GB"
fi
echo ""

# Check 7: Network Connectivity
print_status "INFO" "Checking network connectivity..."
if ping -c 1 8.8.8.8 &> /dev/null; then
    print_status "PASS" "Internet connectivity available"
else
    print_status "WARN" "No internet connectivity detected"
fi
echo ""

# Check 8: Git
print_status "INFO" "Checking Git installation..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    echo "  Git version: $GIT_VERSION"
    print_status "PASS" "Git is installed"
else
    print_status "FAIL" "Git not found"
fi
echo ""

# Check 9: SSH
print_status "INFO" "Checking SSH..."
if command -v ssh &> /dev/null; then
    print_status "PASS" "SSH client is installed"
else
    print_status "WARN" "SSH client not found"
fi
echo ""

# Check 10: Sudo access
print_status "INFO" "Checking sudo access..."
if sudo -n true 2>/dev/null; then
    print_status "PASS" "Passwordless sudo configured"
elif sudo -v 2>/dev/null; then
    print_status "WARN" "Sudo available but requires password"
else
    print_status "FAIL" "Sudo access not available"
fi
echo ""

# Print summary
echo "=========================================="
echo "Summary"
echo "=========================================="
echo -e "${GREEN}Passed:${NC}   $PASSED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo -e "${RED}Failed:${NC}   $FAILED"
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}✓ System meets all requirements!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Install Python dependencies: pip3 install -r requirements.txt"
    echo "  2. Run the interactive installer: python3 tui/installer.py"
    echo "  3. Or use Ansible directly: ansible-playbook -i inventory/hosts.ini sites.yml"
    exit 0
else
    echo -e "${RED}✗ System does not meet all requirements${NC}"
    echo ""
    echo "Please address the failed checks above before proceeding."
    exit 1
fi
