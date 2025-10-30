# CloudCurio Infrastructure Tests

This directory contains all testing infrastructure for the CloudCurio Infrastructure project.

## Directory Structure

```
tests/
├── playbooks/       # Ansible test playbooks
├── unit/           # Unit tests (future)
└── integration/    # Integration tests (future)
```

## Test Playbooks

### Available Test Playbooks

#### 1. Docker Installation Test (`test_docker_installation.yml`)
Tests Docker and Docker Compose installation and functionality.

**What it tests:**
- Docker binary is installed
- Docker service is running
- Docker can run containers (hello-world test)
- Docker Compose is installed
- Docker networking is functional

**Usage:**
```bash
ansible-playbook -i ../inventory/hosts.ini playbooks/test_docker_installation.yml
```

#### 2. Monitoring Stack Test (`test_monitoring_stack.yml`)
Tests the monitoring stack components.

**What it tests:**
- Prometheus installation and health
- Grafana installation and health
- Loki installation
- Service status checks
- API endpoint availability

**Usage:**
```bash
ansible-playbook -i ../inventory/hosts.ini playbooks/test_monitoring_stack.yml
```

#### 3. ZeroTier Installation Test (`test_zerotier_installation.yml`)
Tests ZeroTier mesh networking installation.

**What it tests:**
- ZeroTier binary is installed
- ZeroTier service is running
- Node information retrieval
- Network list retrieval
- ZeroTier network interfaces

**Usage:**
```bash
ansible-playbook -i ../inventory/hosts.ini playbooks/test_zerotier_installation.yml
```

## Running Tests

### Using the Test Runner

The easiest way to run tests is using the test runner script:

```bash
# From repository root
bash scripts/run_tests.sh

# Options:
# 1) Run all tests
# 2) Run Ansible playbook tests only
# 3) Run validation tests only
# 4) Run network tests only
# 5) Quick smoke test
```

### Running Individual Tests

```bash
# Test Docker
ansible-playbook -i inventory/hosts.ini tests/playbooks/test_docker_installation.yml

# Test monitoring stack
ansible-playbook -i inventory/hosts.ini tests/playbooks/test_monitoring_stack.yml

# Test ZeroTier
ansible-playbook -i inventory/hosts.ini tests/playbooks/test_zerotier_installation.yml
```

### Dry Run (Check Mode)

Test what would happen without making changes:

```bash
ansible-playbook --check -i inventory/hosts.ini tests/playbooks/test_docker_installation.yml
```

### Verbose Output

For debugging, use verbose mode:

```bash
ansible-playbook -vvv -i inventory/hosts.ini tests/playbooks/test_docker_installation.yml
```

## Test Requirements

### Prerequisites

1. **Ansible** 2.9 or higher
2. **SSH access** to target hosts
3. **Python 3** on target hosts
4. **Proper inventory** configuration

### Inventory Setup

Ensure your inventory file (`inventory/hosts.ini`) is properly configured:

```ini
[all]
node1 ansible_host=172.28.0.1 ansible_user=your_user
node2 ansible_host=172.28.0.2 ansible_user=your_user

[zerotier_nodes]
node1
node2
```

## Test Results

### Successful Test Output

When all tests pass, you'll see:
```
PLAY RECAP *********************************************************************
node1                      : ok=10   changed=0    unreachable=0    failed=0
```

### Failed Test Output

If a test fails, you'll see:
```
TASK [Assert Docker is installed] **********************************************
fatal: [node1]: FAILED! => {"assertion": "docker_version.rc == 0", "msg": "Docker is not installed"}
```

## Writing New Tests

### Test Playbook Template

When adding tests for new components, use this template:

```yaml
---
- name: Test <Component> Installation
  hosts: all
  gather_facts: yes
  become: yes

  tasks:
    - name: Check if <component> is installed
      ansible.builtin.command: <component> --version
      register: component_version
      changed_when: false
      failed_when: false

    - name: Display <component> version
      ansible.builtin.debug:
        msg: "<Component> version: {{ component_version.stdout }}"
      when: component_version.rc == 0

    - name: Assert <component> is installed
      ansible.builtin.assert:
        that:
          - component_version.rc == 0
        fail_msg: "<Component> is not installed"
        success_msg: "<Component> is installed"

    - name: Check <component> service status
      ansible.builtin.systemd:
        name: <component>
      register: component_service

    - name: Assert <component> service is running
      ansible.builtin.assert:
        that:
          - component_service.status.ActiveState == "active"
        fail_msg: "<Component> service is not running"
        success_msg: "<Component> service is running"
```

### Test Best Practices

1. **Use `changed_when: false`** for read-only operations
2. **Use `failed_when: false`** for tests that might legitimately fail
3. **Always include assertions** to validate expected outcomes
4. **Provide helpful messages** in assertions
5. **Test both installation and functionality**
6. **Clean up after tests** if they create temporary resources

## Integration with CI/CD

### GitHub Actions Example

```yaml
name: Test Infrastructure

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Ansible
        run: pip install ansible
      - name: Run tests
        run: bash scripts/run_tests.sh
```

## Troubleshooting

### Common Issues

#### 1. "Unreachable" hosts
**Problem:** Ansible cannot connect to hosts

**Solution:**
```bash
# Test SSH connectivity
ssh user@host

# Test Ansible connectivity
ansible all -i inventory/hosts.ini -m ping
```

#### 2. Permission denied
**Problem:** Insufficient permissions for operations

**Solution:**
- Ensure user has sudo privileges
- Check SSH key permissions
- Verify `become: yes` is set in playbook

#### 3. Module not found
**Problem:** Ansible module is not available

**Solution:**
```bash
# Update Ansible
pip install --upgrade ansible

# Install required collections
ansible-galaxy collection install ansible.posix
```

## Additional Resources

- [Main Testing Guide](../TESTING_GUIDE.md) - Comprehensive testing documentation
- [Validation Scripts](../scripts/validators/) - Standalone validation scripts
- [Network Tests](../playbooks/test_network_connectivity.yml) - Network-specific tests
- [Ansible Testing Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tests.html)

## Contributing Tests

When contributing new tests:

1. Follow the test template above
2. Ensure tests are idempotent
3. Add documentation for the test
4. Test on a clean system
5. Update this README

## Support

For test-related issues:
1. Review test output
2. Check target host status
3. Verify prerequisites
4. Consult [TESTING_GUIDE.md](../TESTING_GUIDE.md)
5. Open an issue with full test output
