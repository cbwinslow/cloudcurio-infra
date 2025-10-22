# Troubleshooting Guide

This guide helps you resolve common issues encountered while using CloudCurio Infrastructure.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Ansible Problems](#ansible-problems)
- [Service Issues](#service-issues)
- [Docker Problems](#docker-problems)
- [Network Issues](#network-issues)
- [Permission Errors](#permission-errors)
- [Port Conflicts](#port-conflicts)
- [Database Issues](#database-issues)
- [Getting Help](#getting-help)

---

## Installation Issues

### Python Version Error

**Problem**: `Python 3.8 or higher required`

**Solution**:
```bash
# Check current version
python3 --version

# Install Python 3.11 on Ubuntu
sudo apt update
sudo apt install python3.11 python3.11-venv python3.11-dev

# Set as default
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
```

### Ansible Not Found

**Problem**: `ansible: command not found`

**Solution**:
```bash
# Install Ansible via pip
pip3 install ansible

# Or via apt (older version)
sudo apt update
sudo apt install ansible

# Verify installation
ansible --version
```

### Requirements Check Fails

**Problem**: `check-requirements.sh` reports failures

**Solution**:
```bash
# Run with details
./scripts/check-requirements.sh

# Address each failed check:
# - Install missing packages
# - Free up disk space
# - Configure network
# - Set up sudo access
```

---

## Ansible Problems

### Connection Refused

**Problem**: `Failed to connect to the host via ssh`

**Solution**:
```bash
# Test SSH connection
ssh user@hostname

# Check SSH service
sudo systemctl status sshd

# Verify inventory
cat inventory/hosts.ini

# Test Ansible ping
ansible -i inventory/hosts.ini all -m ping
```

### Permission Denied

**Problem**: `Permission denied` errors during playbook execution

**Solution**:
```bash
# Run with become password
ansible-playbook -i inventory/hosts.ini sites.yml --ask-become-pass

# Or configure passwordless sudo
sudo visudo
# Add: username ALL=(ALL) NOPASSWD: ALL
```

### Module Not Found

**Problem**: `The module docker_image was not found`

**Solution**:
```bash
# Install required collections
ansible-galaxy collection install community.docker
ansible-galaxy collection install community.general

# Verify installation
ansible-galaxy collection list
```

### Role Not Found

**Problem**: `the role 'rolename' was not found`

**Solution**:
```bash
# Verify role exists
ls roles/rolename/

# Check sites.yml syntax
ansible-playbook --syntax-check sites.yml

# Ensure you're in the correct directory
pwd  # Should be in cloudcurio-infra root
```

---

## Service Issues

### Service Won't Start

**Problem**: Service fails to start or crashes immediately

**Solution**:
```bash
# Check service status
sudo systemctl status service-name

# View logs
sudo journalctl -u service-name -n 50

# Check configuration
sudo service-name --test-config

# Restart service
sudo systemctl restart service-name
```

### Service Not Enabled

**Problem**: Service doesn't start on boot

**Solution**:
```bash
# Enable service
sudo systemctl enable service-name

# Verify
sudo systemctl is-enabled service-name

# Start now and enable
sudo systemctl enable --now service-name
```

---

## Docker Problems

### Docker Daemon Not Running

**Problem**: `Cannot connect to the Docker daemon`

**Solution**:
```bash
# Start Docker
sudo systemctl start docker

# Enable Docker on boot
sudo systemctl enable docker

# Check status
sudo systemctl status docker

# View logs if failing
sudo journalctl -u docker -n 50
```

### Permission Denied (Docker)

**Problem**: `permission denied while trying to connect to the Docker daemon`

**Solution**:
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in, or
newgrp docker

# Verify
docker ps
```

### Container Won't Start

**Problem**: Docker container fails to start

**Solution**:
```bash
# Check container logs
docker logs container-name

# Inspect container
docker inspect container-name

# Check for port conflicts
docker ps -a

# Remove and recreate
docker rm container-name
# Re-run ansible playbook
```

### Out of Disk Space

**Problem**: `no space left on device`

**Solution**:
```bash
# Check disk usage
df -h
docker system df

# Clean up
docker system prune -a
docker volume prune

# Remove unused images
docker image prune -a
```

---

## Network Issues

### Cannot Reach Internet

**Problem**: Installation fails due to network connectivity

**Solution**:
```bash
# Test connectivity
ping -c 3 8.8.8.8
ping -c 3 google.com

# Check DNS
cat /etc/resolv.conf

# Test package repositories
sudo apt update

# Check firewall
sudo ufw status
```

### Port Already in Use

**Problem**: `Address already in use`

**Solution**:
```bash
# Find process using port
sudo lsof -i :PORT
sudo ss -tulnp | grep PORT

# Kill process
sudo kill -9 PID

# Or change port in group_vars/devops.yml
# Then re-run ansible playbook
```

### Cannot Access Service

**Problem**: Cannot reach service on expected port

**Solution**:
```bash
# Check if service is listening
sudo ss -tulnp | grep PORT

# Check firewall
sudo ufw status

# Allow port through firewall
sudo ufw allow PORT/tcp

# Check service status
sudo systemctl status service-name
```

---

## Permission Errors

### Sudo Password Required

**Problem**: Ansible keeps asking for sudo password

**Solution**:
```bash
# Option 1: Use --ask-become-pass
ansible-playbook -i inventory/hosts.ini sites.yml --ask-become-pass

# Option 2: Configure passwordless sudo
sudo visudo
# Add: username ALL=(ALL) NOPASSWD: ALL

# Option 3: Use ansible_become_pass in inventory
# (Not recommended for production)
```

### File Permission Denied

**Problem**: Cannot write to directory or file

**Solution**:
```bash
# Check permissions
ls -la /path/to/directory

# Fix ownership
sudo chown -R user:group /path/to/directory

# Fix permissions
sudo chmod -R 755 /path/to/directory
```

---

## Port Conflicts

### Multiple Services on Same Port

**Problem**: Multiple services trying to use port 80, 8080, etc.

**Solution**:
1. Edit `group_vars/devops.yml`
2. Change conflicting ports:
   ```yaml
   nginx_port: 80
   grafana_port: 3002
   prometheus_port: 9090
   # etc.
   ```
3. Re-run playbook:
   ```bash
   ansible-playbook -i inventory/hosts.ini sites.yml
   ```

### View Port Assignments

```bash
# List default ports
./scripts/list-tools.sh --ports

# Check what's listening
sudo ss -tulnp

# Check specific port
sudo lsof -i :PORT
```

---

## Database Issues

### PostgreSQL Won't Start

**Problem**: PostgreSQL service fails to start

**Solution**:
```bash
# Check status and logs
sudo systemctl status postgresql
sudo journalctl -u postgresql -n 50

# Check port availability
sudo ss -tulnp | grep 5432

# Verify data directory permissions
ls -la /var/lib/postgresql/

# Restart
sudo systemctl restart postgresql
```

### MySQL Authentication Error

**Problem**: Cannot connect to MySQL

**Solution**:
```bash
# Reset root password
sudo mysql

# In MySQL:
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'newpassword';
FLUSH PRIVILEGES;
EXIT;

# Test connection
mysql -u root -p
```

### Database Connection Refused

**Problem**: Cannot connect to database from application

**Solution**:
```bash
# Check if database is listening
sudo ss -tulnp | grep PORT

# Check PostgreSQL config
sudo nano /etc/postgresql/*/main/postgresql.conf
# Set: listen_addresses = '*'

# Check pg_hba.conf
sudo nano /etc/postgresql/*/main/pg_hba.conf
# Add: host all all 0.0.0.0/0 md5

# Restart
sudo systemctl restart postgresql
```

---

## Getting Help

### Collect Diagnostic Information

```bash
# System information
./scripts/check-requirements.sh > diagnostics.txt

# Installation status
./scripts/view-status.sh >> diagnostics.txt

# Service status
sudo systemctl status docker prometheus grafana-server >> diagnostics.txt

# Recent logs
sudo journalctl -n 100 >> diagnostics.txt
```

### Verbose Ansible Output

```bash
# Run with maximum verbosity
ansible-playbook -i inventory/hosts.ini sites.yml -vvvv --tags toolname
```

### Enable Debug Mode

```bash
# Add to ansible.cfg
[defaults]
log_path = ./ansible.log
callback_whitelist = profile_tasks

# Run playbook
ansible-playbook -i inventory/hosts.ini sites.yml
```

### Common Commands for Debugging

```bash
# Check system resources
free -h
df -h
top

# Check network
ip addr
ip route
ping -c 3 8.8.8.8

# Check services
sudo systemctl list-units --state=failed
sudo systemctl list-units --type=service --state=running

# Check logs
sudo journalctl -xe
sudo tail -f /var/log/syslog
```

### Where to Get Help

1. **Check documentation**
   - README.md
   - DEVOPS_TOOLS_README.md
   - This troubleshooting guide

2. **Run diagnostics**
   ```bash
   ./scripts/check-requirements.sh
   ./scripts/verify-installation.sh
   ./scripts/view-status.sh
   ```

3. **Search existing issues**
   - [GitHub Issues](https://github.com/cbwinslow/cloudcurio-infra/issues)

4. **Create a new issue**
   - Include diagnostic information
   - Describe steps to reproduce
   - Share error messages
   - Mention your environment (OS, versions, etc.)

5. **Community support**
   - GitHub Discussions
   - Relevant tool documentation
   - Stack Overflow for specific tools

---

## Prevention

### Best Practices

1. **Always check requirements first**
   ```bash
   ./scripts/check-requirements.sh
   ```

2. **Start with dry run**
   ```bash
   ansible-playbook -i inventory/hosts.ini sites.yml --check
   ```

3. **Install incrementally**
   ```bash
   # Test with one tool first
   ansible-playbook -i inventory/hosts.ini sites.yml --tags docker
   
   # Then add more
   ansible-playbook -i inventory/hosts.ini sites.yml --tags "docker,python"
   ```

4. **Keep backups**
   ```bash
   # Backup configurations before changes
   ./scripts/backup-configs.sh
   ```

5. **Monitor resources**
   ```bash
   # Check disk space regularly
   df -h
   
   # Monitor memory
   free -h
   ```

6. **Update regularly**
   ```bash
   # Keep system updated
   sudo apt update && sudo apt upgrade
   
   # Update Ansible
   pip3 install --upgrade ansible
   ```

---

**Still having issues?** Open an issue with detailed information and we'll help!
