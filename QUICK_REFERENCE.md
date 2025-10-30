# Quick Reference Guide

Quick reference for common CloudCurio Infrastructure commands and operations.

## Installation

### Install Components
```bash
# Interactive installer
bash scripts/master_installer.sh

# Install specific component
bash scripts/installers/networking/install_zerotier.sh
bash scripts/installers/container/install_docker.sh
bash scripts/installers/monitoring/install_monitoring_stack.sh
```

### Validate Installation
```bash
# Validate all components
bash scripts/validators/validate_all_components.sh

# Via master installer
bash scripts/master_installer.sh  # Choose option 12
```

### Uninstall Components
```bash
# Interactive uninstaller
bash scripts/master_uninstaller.sh

# Uninstall specific component
bash scripts/uninstallers/networking/uninstall_zerotier.sh
bash scripts/uninstallers/container/uninstall_docker.sh
```

## Testing

### Run Tests
```bash
# Comprehensive test runner
bash scripts/run_tests.sh

# Quick smoke test
echo "5" | bash scripts/run_tests.sh

# Verify repository
bash scripts/verify_setup.sh
```

### Ansible Tests
```bash
# Test Docker installation
ansible-playbook -i inventory/hosts.ini tests/playbooks/test_docker_installation.yml

# Test monitoring stack
ansible-playbook -i inventory/hosts.ini tests/playbooks/test_monitoring_stack.yml

# Test ZeroTier
ansible-playbook -i inventory/hosts.ini tests/playbooks/test_zerotier_installation.yml

# Test network connectivity
ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml
```

## Networking

### Network Diagnostics
```bash
# Comprehensive network check
bash scripts/networking/network_diagnostics.sh

# ZeroTier connectivity test
bash scripts/networking/zerotier_connectivity_test.sh

# Custom IP test
bash scripts/networking/zerotier_connectivity_test.sh 172.28.0.1 172.28.0.10
```

### SSH Tunnels
```bash
# Interactive tunnel helper
bash scripts/networking/ssh_tunnel_helper.sh

# Manual tunnel examples
ssh -L 8080:remote-host:80 user@ssh-server          # Local forward
ssh -R 8080:localhost:80 user@ssh-server             # Remote forward
ssh -D 9050 user@ssh-server                          # SOCKS proxy
```

### Firewall Management
```bash
# Interactive firewall helper
bash scripts/networking/firewall_helper.sh

# Manual firewall commands
sudo ufw status
sudo ufw allow 22/tcp
sudo ufw allow 9993/udp
sudo ufw enable
```

### Network Troubleshooting
```bash
# Ansible-based troubleshooting
ansible-playbook -i inventory/hosts.ini playbooks/network_troubleshooting.yml

# Setup advanced networking
ansible-playbook -i inventory/hosts.ini playbooks/advanced_networking_setup.yml

# Setup SSH tunnels
ansible-playbook -i inventory/hosts.ini playbooks/setup_network_tunnels.yml
```

## ZeroTier

### Basic Commands
```bash
# Get node info
sudo zerotier-cli info

# List networks
sudo zerotier-cli listnetworks

# Join network
sudo zerotier-cli join <network_id>

# Leave network
sudo zerotier-cli leave <network_id>

# List peers
sudo zerotier-cli listpeers
```

### Service Management
```bash
# Check status
systemctl status zerotier-one

# Start/stop/restart
sudo systemctl start zerotier-one
sudo systemctl stop zerotier-one
sudo systemctl restart zerotier-one

# View logs
sudo journalctl -u zerotier-one -n 50
sudo journalctl -u zerotier-one -f
```

## Docker

### Basic Commands
```bash
# Check version
docker --version
docker compose version

# List containers
docker ps
docker ps -a

# View logs
docker logs <container_id>
docker logs -f <container_id>

# Stop/start container
docker stop <container_id>
docker start <container_id>

# Remove container
docker rm <container_id>

# Remove image
docker rmi <image_id>
```

### Service Management
```bash
# Check status
systemctl status docker

# Start/stop/restart
sudo systemctl start docker
sudo systemctl stop docker
sudo systemctl restart docker
```

## Monitoring

### Prometheus
```bash
# Service control
sudo systemctl status prometheus
sudo systemctl restart prometheus

# Access
# http://localhost:9090

# Check health
curl http://localhost:9090/-/healthy
```

### Grafana
```bash
# Service control
sudo systemctl status grafana-server
sudo systemctl restart grafana-server

# Access
# http://localhost:3000
# Default credentials: admin/admin

# Check health
curl http://localhost:3000/api/health
```

### Loki
```bash
# Service control
sudo systemctl status loki
sudo systemctl restart loki

# Access
# http://localhost:3100
```

## Ansible

### Basic Commands
```bash
# Test connectivity
ansible all -i inventory/hosts.ini -m ping

# Run playbook
ansible-playbook -i inventory/hosts.ini playbooks/<playbook>.yml

# Check syntax
ansible-playbook --syntax-check <playbook>.yml

# Dry run
ansible-playbook --check -i inventory/hosts.ini <playbook>.yml

# Verbose output
ansible-playbook -vvv -i inventory/hosts.ini <playbook>.yml
```

### Common Playbooks
```bash
# Test network connectivity
ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml

# Master infrastructure setup
ansible-playbook -i inventory/hosts.ini playbooks/master_infrastructure_setup.yml

# Network troubleshooting
ansible-playbook -i inventory/hosts.ini playbooks/network_troubleshooting.yml

# Advanced networking
ansible-playbook -i inventory/hosts.ini playbooks/advanced_networking_setup.yml
```

## Logs and Troubleshooting

### System Logs
```bash
# View system logs
sudo journalctl -xe

# View service logs
sudo journalctl -u <service-name> -n 50
sudo journalctl -u <service-name> -f

# View network health logs
sudo tail -f /var/log/network-health.log

# View kernel logs
sudo dmesg | tail -50
```

### Common Troubleshooting
```bash
# Check service status
systemctl status <service>

# Check network interfaces
ip addr show
ip link show

# Check routing
ip route show

# Check firewall
sudo ufw status verbose
sudo iptables -L -n

# Check listening ports
sudo netstat -tuln | grep LISTEN
sudo ss -tuln | grep LISTEN

# Test DNS
nslookup google.com
dig google.com

# Test connectivity
ping 8.8.8.8
ping google.com
traceroute google.com
```

## File Locations

### Configuration Files
```
/etc/zerotier-one/          # ZeroTier config
/etc/docker/                # Docker config
/etc/prometheus/            # Prometheus config
/etc/grafana/               # Grafana config
/etc/loki/                  # Loki config
/etc/ufw/                   # Firewall config
```

### Data Directories
```
/var/lib/zerotier-one/      # ZeroTier data
/var/lib/docker/            # Docker data
/var/lib/prometheus/        # Prometheus data
/var/lib/grafana/           # Grafana data
/var/lib/loki/              # Loki data
```

### Log Directories
```
/var/log/network-health.log # Network health monitor
/var/log/grafana/           # Grafana logs
```

### Service Files
```
/etc/systemd/system/        # Systemd service files
```

## Environment Variables

### Docker
```bash
export DOCKER_HOST=tcp://localhost:2375
export DOCKER_BUILDKIT=1
```

### Ansible
```bash
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_INVENTORY=inventory/hosts.ini
```

## Useful Aliases

Add to `~/.bashrc` or `~/.bash_aliases`:

```bash
# CloudCurio Infrastructure
alias cc-install='bash /path/to/cloudcurio-infra/scripts/master_installer.sh'
alias cc-validate='bash /path/to/cloudcurio-infra/scripts/validators/validate_all_components.sh'
alias cc-test='bash /path/to/cloudcurio-infra/scripts/run_tests.sh'
alias cc-network='bash /path/to/cloudcurio-infra/scripts/networking/network_diagnostics.sh'
alias cc-zt='bash /path/to/cloudcurio-infra/scripts/networking/zerotier_connectivity_test.sh'

# Docker
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dlog='docker logs -f'
alias dstop='docker stop $(docker ps -aq)'

# ZeroTier
alias zt-info='sudo zerotier-cli info'
alias zt-nets='sudo zerotier-cli listnetworks'
alias zt-peers='sudo zerotier-cli listpeers'

# System
alias sys-logs='sudo journalctl -xe'
alias net-check='ping -c 3 8.8.8.8 && ping -c 3 google.com'
```

## Getting Help

### Documentation
```bash
# View local documentation
cat QUICKSTART.md
cat TESTING_GUIDE.md
cat NETWORK_TROUBLESHOOTING.md
cat INFRASTRUCTURE_GUIDE.md
```

### Online Resources
- GitHub Issues: https://github.com/cbwinslow/cloudcurio-infra/issues
- ZeroTier Docs: https://docs.zerotier.com/
- Docker Docs: https://docs.docker.com/
- Ansible Docs: https://docs.ansible.com/

## Quick Start Workflow

1. **Clone and verify**:
   ```bash
   git clone https://github.com/cbwinslow/cloudcurio-infra.git
   cd cloudcurio-infra
   bash scripts/verify_setup.sh
   ```

2. **Install components**:
   ```bash
   bash scripts/master_installer.sh
   ```

3. **Validate installation**:
   ```bash
   bash scripts/validators/validate_all_components.sh
   ```

4. **Test network**:
   ```bash
   bash scripts/networking/network_diagnostics.sh
   ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml
   ```

5. **Deploy with Ansible**:
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/master_infrastructure_setup.yml
   ```

6. **Monitor and maintain**:
   ```bash
   # Regular validation
   bash scripts/run_tests.sh
   
   # Network health
   bash scripts/networking/network_diagnostics.sh
   ```
