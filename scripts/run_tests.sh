#!/bin/bash
# Comprehensive test runner for all CloudCurio Infrastructure tests
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Security: Enable audit logging
AUDIT_LOG="/var/log/cloudcurio-tests.log"

audit_log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local user=${SUDO_USER:-$USER}
    echo "[$timestamp] USER=$user ACTION=$1 STATUS=$2 DETAILS=$3" >> "$AUDIT_LOG" 2>/dev/null || true
}

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

header() {
    echo ""
    echo "=============================================="
    echo "$1"
    echo "=============================================="
    echo ""
}

# Track results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

run_test() {
    local test_name=$1
    local test_command=$2
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    info "Running: $test_name"
    
    if eval "$test_command" &> /tmp/test_output_$$.log; then
        success "$test_name PASSED"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        audit_log "TEST_RUN" "PASSED" "$test_name"
        return 0
    else
        error "$test_name FAILED"
        echo "  Error output:"
        # Security: Limit error output to avoid exposing sensitive info
        cat /tmp/test_output_$$.log | head -10 | sed 's/^/    /'
        FAILED_TESTS=$((FAILED_TESTS + 1))
        audit_log "TEST_RUN" "FAILED" "$test_name"
        return 1
    fi
}

header "CloudCurio Infrastructure - Test Runner"
audit_log "TEST_SUITE" "STARTED" "User initiated test run"

echo "Test Execution Options:"
echo "1) Run all tests"
echo "2) Run Ansible playbook tests only"
echo "3) Run validation tests only"
echo "4) Run network tests only"
echo "5) Quick smoke test"
echo "0) Exit"
echo ""

read -p "Choose an option [0-5]: " choice

case $choice in
    1)
        header "Running All Tests"
        
        # Check prerequisites
        info "Checking prerequisites..."
        if ! command -v ansible &> /dev/null; then
            error "Ansible not found - skipping Ansible tests"
            SKIP_ANSIBLE=true
        fi
        
        # Repository verification
        header "Repository Structure Tests"
        run_test "Repository verification" "bash scripts/verify_setup.sh"
        
        # Validation tests
        header "Component Validation Tests"
        run_test "Component validation" "bash scripts/validators/validate_all_components.sh"
        
        # Network tests
        header "Network Tests"
        run_test "Network diagnostics" "bash scripts/networking/network_diagnostics.sh"
        
        if command -v zerotier-cli &> /dev/null; then
            run_test "ZeroTier connectivity" "bash scripts/networking/zerotier_connectivity_test.sh"
        else
            info "ZeroTier not installed - skipping ZeroTier tests"
        fi
        
        # Ansible tests
        if [ "$SKIP_ANSIBLE" != "true" ]; then
            header "Ansible Playbook Tests"
            
            # Check if inventory exists
            if [ -f "inventory/hosts.ini" ]; then
                run_test "Ansible connectivity" "ansible all -i inventory/hosts.ini -m ping"
                run_test "Docker installation test" "ansible-playbook --syntax-check tests/playbooks/test_docker_installation.yml"
                run_test "Monitoring stack test" "ansible-playbook --syntax-check tests/playbooks/test_monitoring_stack.yml"
                run_test "ZeroTier installation test" "ansible-playbook --syntax-check tests/playbooks/test_zerotier_installation.yml"
            else
                info "Inventory file not found - skipping Ansible execution tests"
            fi
        fi
        ;;
        
    2)
        header "Ansible Playbook Tests"
        
        if ! command -v ansible &> /dev/null; then
            error "Ansible not installed"
            exit 1
        fi
        
        run_test "Test network connectivity playbook" "ansible-playbook --syntax-check playbooks/test_network_connectivity.yml"
        run_test "Docker test playbook" "ansible-playbook --syntax-check tests/playbooks/test_docker_installation.yml"
        run_test "Monitoring test playbook" "ansible-playbook --syntax-check tests/playbooks/test_monitoring_stack.yml"
        run_test "ZeroTier test playbook" "ansible-playbook --syntax-check tests/playbooks/test_zerotier_installation.yml"
        run_test "Network troubleshooting playbook" "ansible-playbook --syntax-check playbooks/network_troubleshooting.yml"
        run_test "Advanced networking playbook" "ansible-playbook --syntax-check playbooks/advanced_networking_setup.yml"
        run_test "Setup tunnels playbook" "ansible-playbook --syntax-check playbooks/setup_network_tunnels.yml"
        ;;
        
    3)
        header "Validation Tests"
        run_test "Repository verification" "bash scripts/verify_setup.sh"
        run_test "Component validation" "bash scripts/validators/validate_all_components.sh"
        ;;
        
    4)
        header "Network Tests"
        run_test "Network diagnostics" "bash scripts/networking/network_diagnostics.sh"
        
        if command -v zerotier-cli &> /dev/null; then
            run_test "ZeroTier connectivity" "bash scripts/networking/zerotier_connectivity_test.sh"
        else
            info "ZeroTier not installed - skipping ZeroTier tests"
        fi
        
        if command -v ansible &> /dev/null && [ -f "inventory/hosts.ini" ]; then
            run_test "Ansible network connectivity" "ansible-playbook --syntax-check playbooks/test_network_connectivity.yml"
        fi
        ;;
        
    5)
        header "Quick Smoke Test"
        run_test "Repository structure" "test -d roles && test -d playbooks && test -d scripts"
        run_test "Essential scripts exist" "test -f scripts/master_installer.sh && test -f scripts/verify_setup.sh"
        run_test "Network diagnostic script" "test -x scripts/networking/network_diagnostics.sh"
        run_test "Validation script" "test -x scripts/validators/validate_all_components.sh"
        
        if command -v ansible &> /dev/null; then
            run_test "Ansible syntax" "ansible-playbook --syntax-check playbooks/test_network_connectivity.yml"
        fi
        ;;
        
    0)
        echo "Exiting..."
        exit 0
        ;;
        
    *)
        error "Invalid choice"
        exit 1
        ;;
esac

# Cleanup
rm -f /tmp/test_output_$$.log

# Summary
header "Test Summary"
echo "Total tests run: $TOTAL_TESTS"
echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
echo -e "${RED}Failed: $FAILED_TESTS${NC}"
echo ""
echo "Audit log saved to: $AUDIT_LOG"

if [ $FAILED_TESTS -eq 0 ]; then
    success "All tests passed!"
    audit_log "TEST_SUITE" "COMPLETED" "All tests passed: $PASSED_TESTS/$TOTAL_TESTS"
    exit 0
else
    error "Some tests failed. Review output above for details."
    audit_log "TEST_SUITE" "COMPLETED" "Tests failed: $FAILED_TESTS/$TOTAL_TESTS"
    exit 1
fi
