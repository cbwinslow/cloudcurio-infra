# CloudCurio Infrastructure Setup Guide

Complete guide for setting up servers and desktops using Ansible, Pulumi, and Terraform.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quick Start](#quick-start)
4. [Detailed Setup](#detailed-setup)
5. [Server Setup](#server-setup)
6. [Desktop Setup](#desktop-setup)
7. [SSH Key Management](#ssh-key-management)
8. [Container Orchestration](#container-orchestration)
9. [Pulumi/Terraform Setup](#pulumiterraform-setup)
10. [Troubleshooting](#troubleshooting)

## Overview

CloudCurio Infrastructure provides comprehensive automation for:

- **Server Setup**: Production-ready server configuration
- **Desktop Setup**: Developer workstation configuration
- **SSH Management**: Automated key generation and deployment
- **Container Orchestration**: Docker and compose stacks
- **Cloud Infrastructure**: Pulumi/Terraform for cloud resources
- **Monitoring**: Prometheus, Grafana, Loki stacks
- **Networking**: ZeroTier VPN, Cloudflare Tunnels

## Prerequisites

### Required Software

- **Ansible**: 2.9 or higher
- **Python**: 3.8 or higher
- **Pulumi CLI**: Latest version
- **Terraform**: 1.0 or higher (optional)
- **Docker**: Latest version
- **Git**: Latest version

### Access Requirements

- SSH access to target hosts
- Sudo privileges on target hosts
- Cloudflare account (for cloud resources)
- ZeroTier network (optional, for VPN)

### Installing Prerequisites

#### On Ubuntu/Debian:

```bash
# Install Ansible
sudo apt update
sudo apt install -y ansible python3-pip

# Install Pulumi
curl -fsSL https://get.pulumi.com | sh

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/cbwinslow/cloudcurio-infra.git
cd cloudcurio-infra
```

### 2. Configure Inventory

Edit `inventory/production/hosts.ini`:

```ini
[servers]
myserver ansible_host=192.168.1.100 ansible_user=admin

[desktops]
mydesktop ansible_host=192.168.1.101 ansible_user=user
```

### 3. Test Connectivity

```bash
ansible all -i inventory/production/hosts.ini -m ping
```

### 4. Deploy Infrastructure

```bash
# Setup servers
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml

# Setup desktops
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_desktops.yml
```

## Detailed Setup

### Environment Configuration

The repository supports multiple environments:

- **Production**: `inventory/production/`
- **Staging**: `inventory/staging/`
- **Development**: `inventory/development/`

### Group Variables

Configuration is managed through group variables:

- `group_vars/all.yml`: Common settings for all hosts
- `group_vars/servers.yml`: Server-specific settings
- `group_vars/desktops.yml`: Desktop-specific settings
- `group_vars/zerotier_nodes.yml`: ZeroTier network settings

Edit these files to customize your setup.

## Server Setup

### Full Server Setup

```bash
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml
```

This playbook:
1. Tests connectivity
2. Installs base packages
3. Configures SSH and security
4. Installs Docker and container runtime
5. Deploys monitoring stack
6. Configures networking (ZeroTier, SSH tunnels)
7. Sets up systemd services
8. Configures backups

### Individual Server Tasks

#### Base System Configuration

```bash
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml --tags base
```

#### Security Hardening

```bash
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml --tags security
```

#### Monitoring Stack

```bash
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml --tags monitoring
```

### Server Configuration Options

Edit `group_vars/servers.yml`:

```yaml
# Monitoring
monitoring_enabled: true
prometheus_node_exporter_port: 9100

# Security
ufw_enabled: true
fail2ban_enabled: true
ssh_password_authentication: no

# Backup
backup_enabled: true
backup_retention_days: 30
```

## Desktop Setup

### Full Desktop Setup

```bash
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_desktops.yml
```

This playbook:
1. Tests connectivity
2. Installs desktop packages
3. Installs development tools
4. Configures user environment
5. Sets up Docker for development
6. Configures SSH and Git
7. Installs AI/ML development tools
8. Configures desktop applications

### Individual Desktop Tasks

#### Development Environment

```bash
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_desktops.yml --tags development
```

#### User Configuration

```bash
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_desktops.yml --tags user
```

### Desktop Configuration Options

Edit `group_vars/desktops.yml`:

```yaml
# Development tools
dev_tools_enabled: true
install_vscode: true
install_jetbrains_toolbox: false

# Container development
docker_desktop_mode: true
kubernetes_enabled: false
```

## SSH Key Management

### Setup SSH Keys

```bash
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_ssh_keys.yml
```

This playbook:
1. Generates SSH key pairs on local machine
2. Deploys public keys to all hosts
3. Generates host-specific SSH keys
4. Cross-deploys keys between hosts
5. Configures SSH client settings
6. Hardens SSH server configuration

### SSH Key Features

- Automatic key generation (ED25519)
- Cross-host authentication
- SSH config with host entries
- Jump host support
- Security hardening

### Manual SSH Key Setup

```bash
# Generate key on local machine
ssh-keygen -t ed25519 -C "user@cloudcurio"

# Copy to remote host
ssh-copy-id user@host
```

## Container Orchestration

### Deploy Container Stacks

```bash
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_containers.yml
```

This playbook deploys:
- **Monitoring Stack**: Prometheus, Grafana, Loki, Node Exporter
- **AI/ML Stack**: LocalAI, AnythingLLM, Qdrant, Weaviate, Langfuse
- **Database Stack**: PostgreSQL, MySQL, Redis, MongoDB, Adminer
- **Web Stack**: Caddy, Nginx, Portainer

### Container Stack Configuration

Edit docker-compose templates:
- `docker/monitoring-stack.yml.j2`
- `docker/ai-ml-stack.yml.j2`
- `docker/database-stack.yml.j2`
- `docker/web-stack.yml.j2`

### Managing Container Stacks

```bash
# Start all stacks
docker-compose -f /opt/containers/monitoring/docker-compose.yml up -d

# View logs
docker-compose -f /opt/containers/monitoring/docker-compose.yml logs -f

# Stop stack
docker-compose -f /opt/containers/monitoring/docker-compose.yml down
```

## Pulumi/Terraform Setup

### CloudCurio Pulumi Library

The custom Pulumi library provides reusable components:

```bash
cd pulumi/infrastructure
pip install -r requirements.txt
pulumi login
pulumi stack init cloudcurio-prod
pulumi up
```

See [PULUMI_GUIDE.md](PULUMI_GUIDE.md) for detailed information.

### Available Stacks

1. **Infrastructure Stack**: Complete infrastructure deployment
2. **Networking Stack**: DNS, tunnels, network configuration
3. **Security Stack**: WAF, Access policies, security rules
4. **Cloudflare Stack**: Cloudflare-specific resources
5. **Vercel Stack**: Vercel deployment configuration

### Terraform Alternative

```bash
cd terraform/cloudflare
terraform init
terraform plan
terraform apply
```

## Troubleshooting

### Ansible Connection Issues

```bash
# Test connectivity
ansible all -i inventory/production/hosts.ini -m ping

# Verbose output
ansible-playbook -vvv playbooks/setup_servers.yml
```

### SSH Issues

```bash
# Check SSH configuration
ssh -v user@host

# Test key authentication
ssh -i ~/.ssh/id_ed25519 user@host
```

### Docker Issues

```bash
# Check Docker status
systemctl status docker

# View Docker logs
journalctl -u docker -f

# Restart Docker
sudo systemctl restart docker
```

### Pulumi Issues

```bash
# Refresh state
pulumi refresh

# View detailed logs
pulumi up --logtostderr -v=9
```

## Next Steps

1. **Review Configuration**: Check group_vars for your environment
2. **Test in Staging**: Deploy to staging environment first
3. **Deploy Monitoring**: Set up monitoring before production deployment
4. **Configure Backups**: Ensure backup scripts are running
5. **Security Review**: Review security settings and firewall rules
6. **Documentation**: Document any customizations

## Support

- **Issues**: [GitHub Issues](https://github.com/cbwinslow/cloudcurio-infra/issues)
- **Discussions**: [GitHub Discussions](https://github.com/cbwinslow/cloudcurio-infra/discussions)
- **Documentation**: See other guides in this repository
