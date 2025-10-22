# Installation Guide

This comprehensive guide walks you through installing CloudCurio Infrastructure from start to finish.

## Table of Contents

- [Before You Begin](#before-you-begin)
- [System Requirements](#system-requirements)
- [Installation Methods](#installation-methods)
- [Step-by-Step Installation](#step-by-step-installation)
- [Post-Installation](#post-installation)
- [Common Scenarios](#common-scenarios)
- [Troubleshooting](#troubleshooting)

---

## Before You Begin

### What You'll Need

- A Linux system (Ubuntu 20.04+, Debian 10+, or compatible)
- Root or sudo access
- Internet connectivity
- Basic command-line knowledge
- 30-60 minutes (depending on selections)

### What You'll Get

A fully configured DevOps environment with your choice of:
- Programming languages (Python, Node.js, PHP)
- Container platforms (Docker, Podman)
- Databases (PostgreSQL, MySQL, and more)
- Monitoring tools (Grafana, Prometheus, Loki)
- AI/ML tools (Ollama, LocalAI, OpenWebUI)
- And 70+ more tools

---

## System Requirements

### Minimum Requirements

```
Operating System: Ubuntu 20.04+ or Debian 10+
CPU: 2 cores
RAM: 4 GB
Disk: 10 GB free space
Network: Internet connectivity
```

### Recommended Requirements

```
Operating System: Ubuntu 22.04 LTS
CPU: 4+ cores
RAM: 8 GB (16 GB for AI/ML tools)
Disk: 50 GB+ free space (SSD recommended)
Network: High-speed internet
```

### Software Prerequisites

```bash
# Required
- Python 3.8+
- pip3
- git
- sudo access

# Installed automatically
- Ansible 2.9+
- Various system packages
```

---

## Installation Methods

CloudCurio Infrastructure offers three installation methods:

### 1. Interactive TUI (Recommended for Beginners)

Visual terminal interface with guided selection.

**Pros:**
- Easy to use
- Visual feedback
- Browse and select tools
- See installation progress

**Best for:**
- First-time users
- Visual learners
- Exploring available tools

### 2. Installation Wizard (Good for Most Users)

Command-line wizard with step-by-step guidance.

**Pros:**
- No additional dependencies
- Pre-configured stacks
- Guided prompts
- Confirmation steps

**Best for:**
- Standard installations
- Pre-configured stacks
- Users who prefer CLI

### 3. Direct Ansible (Advanced Users)

Direct use of Ansible playbooks.

**Pros:**
- Full control
- Scriptable
- CI/CD integration
- Fastest method

**Best for:**
- Experienced users
- Automation
- Custom configurations

---

## Step-by-Step Installation

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/cbwinslow/cloudcurio-infra.git

# Navigate to directory
cd cloudcurio-infra

# Verify contents
ls -la
```

### Step 2: Check System Requirements

```bash
# Run the requirements checker
./scripts/check-requirements.sh

# Review output for any failures
# Address any issues before continuing
```

Expected output:
```
✓ Ubuntu version 22.04 is supported
✓ Python 3.10 meets requirements
✓ pip3 is installed
✓ Ansible is installed
✓ Sufficient disk space available
✓ Sufficient memory
✓ Internet connectivity available
✓ Git is installed
✓ SSH client is installed
```

### Step 3: Install Python Dependencies

```bash
# Install required Python packages
pip3 install -r requirements.txt

# Verify textual is installed (for TUI)
python3 -c "import textual; print('✓ Textual installed')"

# Install Ansible collections
ansible-galaxy collection install community.docker
ansible-galaxy collection install community.general
```

### Step 4: Configure Inventory (Optional)

The default inventory is configured for localhost. To target remote hosts:

```bash
# Edit inventory file
nano inventory/hosts.ini

# Add your hosts
[devops]
myserver ansible_host=192.168.1.100 ansible_user=myuser
```

### Step 5: Configure Variables (Optional)

Customize installation settings:

```bash
# Edit configuration
nano group_vars/devops.yml

# Example customizations:
# python_version: "3.11"
# grafana_port: 3002
# docker_users: ["myuser"]
```

### Step 6: Choose Installation Method

#### Option A: Interactive TUI

```bash
# Start the TUI
python3 tui/installer.py

# Follow on-screen instructions:
# 1. Browse categories
# 2. Select tools
# 3. Review selections
# 4. Confirm installation
# 5. Monitor progress
```

#### Option B: Installation Wizard

```bash
# Start the wizard
./scripts/install-wizard.sh

# Follow the prompts:
# 1. Choose installation type
# 2. Select stack or tools
# 3. Confirm installation
# 4. Wait for completion
# 5. Verify installation
```

#### Option C: Direct Ansible

```bash
# Install everything
ansible-playbook -i inventory/hosts.ini sites.yml

# OR install specific tools
ansible-playbook -i inventory/hosts.ini sites.yml --tags "docker,python,grafana"

# OR install by category
ansible-playbook -i inventory/hosts.ini sites.yml --tags "database,monitoring"
```

### Step 7: Monitor Installation

The installation process will:
1. Update package cache
2. Install system dependencies
3. Add repositories
4. Install selected tools
5. Configure services
6. Start services

**Time estimates:**
- Minimal install (Python, Docker): 5-10 minutes
- Development stack: 15-20 minutes
- Full install: 30-60 minutes

### Step 8: Verify Installation

```bash
# Run verification script
./scripts/verify-installation.sh

# Check specific tool
./scripts/verify-installation.sh --tool grafana

# View status
./scripts/view-status.sh
```

Expected output:
```
✓ Python installed: 3.10.12
✓ Docker installed: Docker version 24.0.5
✓ Docker daemon service is running
✓ PostgreSQL service is running
✓ Grafana service is running
```

---

## Post-Installation

### Access Installed Services

```bash
# List all services with ports
./scripts/list-tools.sh --ports

# Common services:
# Grafana:    http://localhost:3002
# Prometheus: http://localhost:9090
# Ollama API: http://localhost:11434
```

### Default Credentials

Most services use these defaults (change immediately!):

```
Grafana:
  Username: admin
  Password: changeme

Keycloak:
  Username: admin
  Password: changeme

MySQL/PostgreSQL:
  Check group_vars/devops.yml for credentials
```

### First Steps

1. **Change default passwords**
   ```bash
   # Use Ansible Vault for sensitive data
   ansible-vault create group_vars/vault.yml
   ```

2. **Configure services**
   - Add Prometheus data source to Grafana
   - Create database users
   - Configure firewalls if needed

3. **Test functionality**
   ```bash
   # Test Docker
   docker run hello-world
   
   # Test Ollama
   ollama run llama2 "Hello!"
   
   # Test Python
   python3 -c "import sys; print(sys.version)"
   ```

4. **Set up monitoring**
   - Access Grafana
   - Import dashboards
   - Configure alerts

### Securing Your Installation

```bash
# 1. Change all default passwords

# 2. Configure firewall
sudo ufw enable
sudo ufw allow 22/tcp  # SSH
sudo ufw allow 3002/tcp  # Grafana
# Add other services as needed

# 3. Set up SSL/TLS for web services
# Consider using Caddy or Traefik for automatic HTTPS

# 4. Regular updates
sudo apt update && sudo apt upgrade
pip3 install --upgrade ansible
```

---

## Common Scenarios

### Scenario 1: Development Workstation

**Goal:** Set up a local development environment

```bash
# Method 1: Using wizard
./scripts/install-wizard.sh
# Choose: Pre-configured Stack > Development Workstation

# Method 2: Using Ansible
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "python,nodejs,docker,git,vscode,postgresql"
```

**Includes:**
- Python 3.11 with common packages
- Node.js 20 with npm/yarn/pnpm
- Docker and Docker Compose
- Git
- VS Code
- PostgreSQL

### Scenario 2: AI/ML Research Environment

**Goal:** Run LLMs and ML experiments locally

```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "python,docker,ollama,localai,openwebui,flowise,haystack"
```

**Includes:**
- Python with ML libraries
- Docker for containerized workloads
- Ollama for running LLMs
- LocalAI for API compatibility
- Open WebUI for chat interface
- Flowise for visual AI workflows

**Post-install:**
```bash
# Pull AI models
ollama pull llama2
ollama pull codellama
ollama pull mistral

# Access Open WebUI
firefox http://localhost:3000
```

### Scenario 3: Monitoring Server

**Goal:** Set up centralized monitoring

```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "prometheus,grafana,loki,alertmanager,node-exporter"
```

**Includes:**
- Prometheus for metrics
- Grafana for visualization
- Loki for logs
- Alert manager for notifications

**Post-install:**
- Import Prometheus dashboards to Grafana
- Configure log shipping to Loki
- Set up alert rules

### Scenario 4: Web Development Stack

**Goal:** Full web development environment

```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "nodejs,php,mysql,nginx,redis,git"
```

**Includes:**
- Node.js and PHP
- MySQL database
- Nginx web server
- Redis cache
- Git

---

## Troubleshooting

### Installation Fails

```bash
# Check requirements again
./scripts/check-requirements.sh

# Run with verbose output
ansible-playbook -i inventory/hosts.ini sites.yml -vvv

# Check logs
sudo journalctl -xe
```

### Service Won't Start

```bash
# Check service status
sudo systemctl status service-name

# View logs
sudo journalctl -u service-name -n 50

# Restart service
sudo systemctl restart service-name
```

### Port Conflicts

```bash
# Check what's using the port
sudo lsof -i :PORT

# Change port in group_vars/devops.yml
nano group_vars/devops.yml

# Rerun playbook
ansible-playbook -i inventory/hosts.ini sites.yml --tags tool-name
```

For more troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## Next Steps

- Read [QUICK_REFERENCE.md](../QUICK_REFERENCE.md) for command examples
- See [DEVOPS_TOOLS_README.md](../DEVOPS_TOOLS_README.md) for tool details
- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues
- Review [CONTRIBUTING.md](../CONTRIBUTING.md) to contribute

---

**Need help?** Open an issue on GitHub or check existing documentation.
