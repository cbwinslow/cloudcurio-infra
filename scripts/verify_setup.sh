#!/bin/bash
# Verification script for CloudCurio Infrastructure setup
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "=========================================="
echo "CloudCurio Infrastructure - Verification"
echo "=========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

warning() {
    echo -e "${YELLOW}!${NC} $1"
}

# Check prerequisites
echo "=== Checking Prerequisites ==="

# Check Ansible
if command -v ansible &> /dev/null; then
    ANSIBLE_VERSION=$(ansible --version | head -n1)
    success "Ansible found: $ANSIBLE_VERSION"
else
    error "Ansible not found. Install with: pip install ansible"
    exit 1
fi

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    success "Python found: $PYTHON_VERSION"
else
    error "Python 3 not found"
    exit 1
fi

# Check Git
if command -v git &> /dev/null; then
    success "Git found"
else
    warning "Git not found (optional)"
fi

echo ""
echo "=== Checking Repository Structure ==="

# Check key directories
directories=("roles" "playbooks" "inventory" "group_vars" "templates" "scripts")
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        success "Directory exists: $dir"
    else
        error "Directory missing: $dir"
    fi
done

echo ""
echo "=== Checking Configuration Files ==="

# Check key files
files=(
    "inventory/hosts.ini"
    "group_vars/all.yml"
    "ansible.cfg"
    "README.md"
    "INFRASTRUCTURE_GUIDE.md"
    "QUICKSTART.md"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        success "File exists: $file"
    else
        error "File missing: $file"
    fi
done

echo ""
echo "=== Checking Ansible Roles ==="

role_categories=("networking" "monitoring" "security" "container" "automation" "ai-ml" "databases" "infrastructure" "web")
total_roles=0

for category in "${role_categories[@]}"; do
    if [ -d "roles/$category" ]; then
        count=$(find "roles/$category" -mindepth 1 -maxdepth 1 -type d | wc -l)
        total_roles=$((total_roles + count))
        success "Category '$category': $count roles found"
    else
        warning "Category '$category': not found"
    fi
done

echo ""
success "Total roles found: $total_roles"

echo ""
echo "=== Checking Playbooks ==="

playbooks=(
    "playbooks/test_network_connectivity.yml"
    "playbooks/master_infrastructure_setup.yml"
)

for playbook in "${playbooks[@]}"; do
    if [ -f "$playbook" ]; then
        # Try syntax check
        if ansible-playbook --syntax-check "$playbook" &> /dev/null; then
            success "Playbook valid: $playbook"
        else
            error "Playbook has syntax errors: $playbook"
        fi
    else
        error "Playbook missing: $playbook"
    fi
done

echo ""
echo "=== Checking Installer Scripts ==="

installer_dirs=(
    "scripts/installers/networking"
    "scripts/installers/monitoring"
    "scripts/installers/container"
    "scripts/installers/automation"
    "scripts/installers/ai-ml"
    "scripts/installers/web"
    "scripts/installers/security"
    "scripts/installers/infrastructure"
)

total_installers=0
for dir in "${installer_dirs[@]}"; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -name "*.sh" -type f | wc -l)
        total_installers=$((total_installers + count))
        if [ $count -gt 0 ]; then
            success "Found $count installer(s) in: $dir"
        fi
    fi
done

if [ -f "scripts/master_installer.sh" ]; then
    success "Master installer exists"
    total_installers=$((total_installers + 1))
fi

echo ""
success "Total installer scripts found: $total_installers"

echo ""
echo "=== Checking Templates ==="

if [ -d "templates/systemd" ]; then
    systemd_count=$(find templates/systemd -name "*.service" -type f | wc -l)
    success "Systemd templates found: $systemd_count"
fi

if [ -d "templates/cron" ]; then
    cron_count=$(find templates/cron -name "*.cron" -type f | wc -l)
    success "Cron templates found: $cron_count"
fi

echo ""
echo "=== Checking Inventory Configuration ==="

# Check if ZeroTier IPs are configured
if grep -q "172.28" inventory/hosts.ini; then
    success "ZeroTier IPs configured in inventory"
else
    warning "ZeroTier IPs may not be configured"
fi

# Check for zerotier_nodes group
if grep -q "\[zerotier_nodes\]" inventory/hosts.ini; then
    success "zerotier_nodes group found in inventory"
else
    warning "zerotier_nodes group not found in inventory"
fi

echo ""
echo "=== Summary ==="
echo ""

# Count files
total_roles_count=$(find roles -name "main.yml" -path "*/tasks/*" | wc -l)
total_playbooks=$(find playbooks -name "*.yml" -type f | wc -l)
total_docs=$(find . -maxdepth 1 -name "*.md" -type f | wc -l)

echo "Repository Statistics:"
echo "  - Ansible Roles: $total_roles_count"
echo "  - Playbooks: $total_playbooks"
echo "  - Installer Scripts: $total_installers"
echo "  - Documentation Files: $total_docs"

echo ""
echo "=========================================="
echo "Verification Complete!"
echo "=========================================="
echo ""

# Check if we can test connectivity
if command -v ansible &> /dev/null; then
    echo "Next steps:"
    echo "1. Test network connectivity:"
    echo "   ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml"
    echo ""
    echo "2. Deploy infrastructure:"
    echo "   ansible-playbook -i inventory/hosts.ini playbooks/master_infrastructure_setup.yml"
    echo ""
    echo "3. Or use manual installers:"
    echo "   bash scripts/master_installer.sh"
else
    echo "Install Ansible to run automated deployments:"
    echo "  pip install ansible"
fi

echo ""
echo "For detailed documentation, see:"
echo "  - QUICKSTART.md"
echo "  - INFRASTRUCTURE_GUIDE.md"
echo "  - IMPLEMENTATION_SUMMARY.md"
echo ""
