# Testing Guide

This document provides comprehensive information about testing the CloudCurio Infrastructure.

## Overview

The CloudCurio Infrastructure includes multiple testing layers:
- **Ansible Test Playbooks**: Automated testing using Ansible
- **Shell Test Scripts**: Standalone validation scripts
- **Integration Tests**: End-to-end testing of components
- **Network Tests**: Connectivity and network validation

## Test Directory Structure

```
tests/
├── playbooks/           # Ansible test playbooks
│   ├── test_docker_installation.yml
│   ├── test_monitoring_stack.yml
│   └── test_zerotier_installation.yml
├── unit/               # Unit tests (future)
└── integration/        # Integration tests (future)
```

## Running Tests

### 1. Ansible Test Playbooks

Test playbooks validate that components are properly installed and configured.

#### Test Docker Installation
```bash
ansible-playbook -i inventory/hosts.ini tests/playbooks/test_docker_installation.yml
```

This test verifies:
- Docker is installed
- Docker service is running
- Docker can run containers
- Docker Compose is available
- Docker networking is functional

#### Test Monitoring Stack
```bash
ansible-playbook -i inventory/hosts.ini tests/playbooks/test_monitoring_stack.yml
```

This test verifies:
- Prometheus is installed and healthy
- Grafana is installed and healthy
- Loki is installed and running
- Services are accessible on their ports

#### Test ZeroTier Installation
```bash
ansible-playbook -i inventory/hosts.ini tests/playbooks/test_zerotier_installation.yml
```

This test verifies:
- ZeroTier is installed
- ZeroTier service is running
- Networks are joined
- ZeroTier interfaces are active

### 2. Validation Scripts

Standalone scripts that check component status.

#### Validate All Components
```bash
bash scripts/validators/validate_all_components.sh
```

This comprehensive script checks:
- Networking components (ZeroTier, SSH)
- Container tools (Docker, Docker Compose)
- Monitoring stack (Prometheus, Grafana, Loki)
- Security tools (Suricata, Wazuh, fail2ban)
- Web servers (Nginx, Apache, Caddy)
- Automation tools (SaltStack, n8n)
- AI/ML tools (AnythingLLM, LocalAI, Ollama)
- Infrastructure tools (Git, Ansible, Terraform)
- Development tools (Python, Node.js, Go)

Output includes:
- Total checks performed
- Number of passed checks
- Number of failed checks
- Recommendations for missing components

### 3. Network Testing

#### Network Connectivity Test (Ansible)
```bash
ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml
```

This playbook tests:
- Basic ping connectivity
- SSH accessibility
- DNS resolution
- Internet connectivity
- Cross-node connectivity in ZeroTier mesh

#### Network Diagnostics (Shell Script)
```bash
bash scripts/networking/network_diagnostics.sh
```

This script provides:
- Internet connectivity check
- DNS resolution test
- Network interface listing
- Routing table display
- ZeroTier status
- Firewall status
- Listening ports
- Port connectivity tests

#### ZeroTier Connectivity Test
```bash
bash scripts/networking/zerotier_connectivity_test.sh
```

Specifically tests ZeroTier mesh networking:
- Node information
- Joined networks
- Peer connectivity
- Interface status
- Service status

You can provide custom IPs to test:
```bash
bash scripts/networking/zerotier_connectivity_test.sh 172.28.0.1 172.28.0.10 172.28.0.20
```

### 4. Repository Verification

Verify repository structure and configuration:
```bash
bash scripts/verify_setup.sh
```

This checks:
- Prerequisites (Ansible, Python, Git)
- Repository structure
- Configuration files
- Ansible roles
- Playbooks syntax
- Installer scripts
- Templates
- Inventory configuration

## Test from Master Installer

The master installer includes a validation option:
```bash
bash scripts/master_installer.sh
# Select option 12: Validate Installations
```

## Continuous Testing

For production environments, consider:

1. **Regular validation runs**:
```bash
# Add to crontab
0 */6 * * * /path/to/cloudcurio-infra/scripts/validators/validate_all_components.sh >> /var/log/component-validation.log 2>&1
```

2. **Network health monitoring**:
```bash
# Enable persistent network monitoring
ansible-playbook -i inventory/hosts.ini playbooks/advanced_networking_setup.yml
```

This sets up continuous network health monitoring that:
- Tests internet connectivity every minute
- Tests DNS resolution
- Monitors ZeroTier status
- Attempts automatic recovery on failures
- Logs all results to `/var/log/network-health.log`

## Troubleshooting Test Failures

### Ansible Test Failures

1. **Connection failures**:
   - Verify SSH access: `ssh user@host`
   - Check inventory file: `cat inventory/hosts.ini`
   - Test with: `ansible all -i inventory/hosts.ini -m ping`

2. **Service not running**:
   - Check service status: `systemctl status <service>`
   - Review logs: `journalctl -u <service> -n 50`
   - Restart service: `systemctl restart <service>`

3. **Package not installed**:
   - Run installer: `bash scripts/installers/<category>/install_<component>.sh`
   - Check package: `dpkg -l | grep <package>`

### Network Test Failures

1. **No internet connectivity**:
   - Check network interfaces: `ip addr show`
   - Check routing: `ip route show`
   - Test DNS: `nslookup google.com`
   - Run diagnostics: `bash scripts/networking/network_diagnostics.sh`

2. **ZeroTier issues**:
   - Check service: `systemctl status zerotier-one`
   - Check networks: `sudo zerotier-cli listnetworks`
   - Check peers: `sudo zerotier-cli listpeers`
   - Review logs: `sudo journalctl -u zerotier-one -n 50`

3. **Firewall blocking**:
   - Check firewall: `sudo ufw status`
   - Add rules: `bash scripts/networking/firewall_helper.sh`
   - Temporarily disable: `sudo ufw disable` (for testing only)

## Best Practices

1. **Test after installation**: Always run validation after installing new components
2. **Regular testing**: Schedule periodic validation runs
3. **Document failures**: Keep logs of test failures for troubleshooting
4. **Test in isolation**: Test individual components before full stack tests
5. **Network testing**: Always test network connectivity before deploying services
6. **Keep tests updated**: Update tests when adding new components

## Writing New Tests

When adding new components, create corresponding tests:

### Ansible Test Playbook Template
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

## Additional Resources

- [Ansible Testing Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tests.html)
- [Infrastructure Testing Best Practices](https://www.inspec.io/)
- [Network Testing Tools](https://github.com/nicolaka/netshoot)

## Support

For test-related issues:
1. Review test output carefully
2. Check component logs
3. Run diagnostic scripts
4. Open an issue with test output and logs
