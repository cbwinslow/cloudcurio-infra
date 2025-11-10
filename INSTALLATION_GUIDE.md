# CloudCurio Software Installation Guide

Complete guide for installing and configuring 55+ DevOps, monitoring, analytics, and development tools.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Prerequisites](#prerequisites)
3. [Installation Methods](#installation-methods)
4. [Step-by-Step Installation](#step-by-step-installation)
5. [Docker Compose Deployments](#docker-compose-deployments)
6. [Ansible Automated Deployment](#ansible-automated-deployment)
7. [Post-Installation Configuration](#post-installation-configuration)
8. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Option 1: Interactive Master Installer (Recommended for Beginners)

```bash
# Clone the repository
git clone https://github.com/cbwinslow/cloudcurio-infra.git
cd cloudcurio-infra

# Run the interactive installer
sudo bash scripts/installers/master_software_installer.sh
```

### Option 2: Docker Compose (Fastest)

```bash
cd cloudcurio-infra

# Start a specific service
docker-compose -f docker/compose/monitoring/zabbix.yml up -d

# Or multiple services
docker-compose -f docker/compose/analytics/metabase.yml up -d
docker-compose -f docker/compose/automation/stackstorm.yml up -d
```

### Option 3: Ansible (Best for Multiple Servers)

```bash
cd cloudcurio-infra

# Install everything
ansible-playbook -i inventory/hosts.ini playbooks/install_all_software.yml

# Or specific categories
ansible-playbook -i inventory/hosts.ini playbooks/install_monitoring_tools.yml
```

---

## Prerequisites

### System Requirements

**Minimum for Testing:**
- 4GB RAM
- 2 CPU cores
- 20GB disk space
- Ubuntu 20.04+ / Debian 11+

**Recommended for Production:**
- 8GB+ RAM
- 4+ CPU cores
- 50GB+ SSD storage
- Ubuntu 22.04 LTS

### Software Requirements

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install basic tools
sudo apt install -y curl wget git build-essential

# Install Docker (for Docker Compose method)
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Ansible (for Ansible method)
sudo apt install -y ansible
```

---

## Installation Methods

### Method 1: Bare Metal Installation Scripts

Each software has a dedicated installation script with comprehensive error handling.

**Advantages:**
- Direct installation on host system
- Full control over configuration
- Better performance (no containerization overhead)
- Persistent across reboots

**Location:** `scripts/installers/`

**Structure:**
```
scripts/installers/
├── monitoring/          # OpenNMS, Zabbix
├── automation/          # Leon, Automatisch, StackStorm, Eonza, Kibitzr
├── analytics/           # Metabase, Superset, OWA
├── data/               # Kafka, Cassandra, Parseable
├── ai-ml/              # LangChain, LangGraph, Matchering
├── gaming/             # LinuxGSM
├── cms/                # Hugo
├── frameworks/         # Next.js, Astro
├── development/        # TypeScript LSP, Python LSP
├── ai-tools/           # Gemini CLI, Cline, Codex CLI, etc.
└── system/             # OliveTin, vstat, vtstat, statpak
```

### Method 2: Docker Compose

Pre-configured Docker Compose files for quick deployment.

**Advantages:**
- Fastest deployment
- Isolated environments
- Easy updates and rollbacks
- Consistent across systems

**Location:** `docker/compose/`

### Method 3: Ansible Playbooks

Automated deployment for single or multiple servers.

**Advantages:**
- Idempotent operations
- Multi-server deployment
- Configuration management
- Integration with existing infrastructure

**Location:** `playbooks/`

---

## Step-by-Step Installation

### Installing Monitoring Tools

#### OpenNMS (Enterprise Network Monitoring)

**Bare Metal:**
```bash
sudo bash scripts/installers/monitoring/install_opennms.sh
```

**Docker Compose:**
```bash
docker-compose -f docker/compose/monitoring/opennms.yml up -d
```

**Access:** http://localhost:8980/opennms  
**Credentials:** admin / admin

#### Zabbix (Complete Monitoring Solution)

**Bare Metal:**
```bash
sudo bash scripts/installers/monitoring/install_zabbix.sh
```

**Docker Compose:**
```bash
docker-compose -f docker/compose/monitoring/zabbix.yml up -d
```

**Access:** http://localhost:8080  
**Credentials:** Admin / zabbix

### Installing Automation Platforms

#### Leon (Open-Source Personal Assistant)

**Bare Metal:**
```bash
sudo bash scripts/installers/automation/install_leon.sh
```

**Docker Compose:**
```bash
docker-compose -f docker/compose/automation/leon.yml up -d
```

**Access:** http://localhost:1337

#### Automatisch (Workflow Automation)

**Bare Metal:**
```bash
sudo bash scripts/installers/automation/install_automatisch.sh
```

**Docker Compose:**
```bash
docker-compose -f docker/compose/automation/automatisch.yml up -d
```

**Access:** http://localhost:3000

#### StackStorm (Event-Driven Automation)

**Docker Compose (Recommended):**
```bash
docker-compose -f docker/compose/automation/stackstorm.yml up -d
```

**Access:** https://localhost  
**Credentials:** st2admin / Ch@ngeMe

### Installing Analytics Tools

#### Metabase (Business Intelligence)

**Bare Metal:**
```bash
sudo bash scripts/installers/analytics/install_metabase.sh
```

**Docker Compose:**
```bash
docker-compose -f docker/compose/analytics/metabase.yml up -d
```

**Access:** http://localhost:3000

#### Apache Superset (Data Visualization)

**Bare Metal:**
```bash
sudo bash scripts/installers/analytics/install_superset.sh
```

**Docker Compose:**
```bash
docker-compose -f docker/compose/analytics/superset.yml up -d
```

**Access:** http://localhost:8088  
**Credentials:** admin / admin

#### PostHog (Product Analytics)

**Docker Compose:**
```bash
docker-compose -f docker/compose/analytics/posthog.yml up -d
```

**Access:** http://localhost:8000

### Installing Data Infrastructure

#### Apache Kafka (Event Streaming)

**Bare Metal:**
```bash
sudo bash scripts/installers/data/install_kafka.sh
```

**Docker Compose:**
```bash
docker-compose -f docker/compose/data/kafka.yml up -d
```

**Kafka Broker:** localhost:9092  
**Kafka UI:** http://localhost:8080

#### Apache Cassandra (NoSQL Database)

**Bare Metal:**
```bash
sudo bash scripts/installers/data/install_cassandra.sh
```

**Docker Compose:**
```bash
docker-compose -f docker/compose/data/cassandra.yml up -d
```

**CQL Port:** 9042

### Installing CMS and Frameworks

#### WordPress (CMS)

**Docker Compose:**
```bash
docker-compose -f docker/compose/cms/wordpress.yml up -d
```

**Access:** http://localhost:8080  
**phpMyAdmin:** http://localhost:8081

#### Ghost (Headless CMS)

**Docker Compose:**
```bash
docker-compose -f docker/compose/cms/ghost.yml up -d
```

**Access:** http://localhost:2368

#### Hugo (Static Site Generator)

**Bare Metal:**
```bash
sudo bash scripts/installers/cms/install_hugo.sh
```

### Installing Development Tools

#### TypeScript Language Server

```bash
sudo bash scripts/installers/development/install_typescript_lsp.sh
```

#### Python Language Server

```bash
sudo bash scripts/installers/development/install_python_lsp.sh
```

#### OliveTin (Web UI for Shell Commands)

**Bare Metal:**
```bash
sudo bash scripts/installers/system/install_olivetin.sh
```

**Docker Compose:**
```bash
docker-compose -f docker/compose/system/olivetin.yml up -d
```

**Access:** http://localhost:1337

### Installing AI Tools

#### LangChain & LangGraph

```bash
bash scripts/installers/ai-ml/install_langchain.sh
bash scripts/installers/ai-ml/install_langgraph.sh
```

#### AI CLI Tools

```bash
# Gemini CLI
bash scripts/installers/ai-tools/install_gemini_cli.sh

# Cline
bash scripts/installers/ai-tools/install_cline.sh

# Codex CLI
bash scripts/installers/ai-tools/install_codex_cli.sh
```

---

## Docker Compose Deployments

### Starting Services

```bash
# Start service in detached mode
docker-compose -f docker/compose/SERVICE/service.yml up -d

# View logs
docker-compose -f docker/compose/SERVICE/service.yml logs -f

# Stop service
docker-compose -f docker/compose/SERVICE/service.yml down

# Stop and remove volumes (data loss!)
docker-compose -f docker/compose/SERVICE/service.yml down -v
```

### Managing Multiple Services

```bash
# Start multiple services
docker-compose -f docker/compose/monitoring/zabbix.yml \
               -f docker/compose/analytics/metabase.yml \
               up -d

# Or use individual commands
cd docker/compose
docker-compose -f monitoring/zabbix.yml up -d
docker-compose -f analytics/metabase.yml up -d
docker-compose -f automation/stackstorm.yml up -d
```

### Updating Services

```bash
# Pull latest images
docker-compose -f docker/compose/SERVICE/service.yml pull

# Restart with new images
docker-compose -f docker/compose/SERVICE/service.yml up -d
```

---

## Ansible Automated Deployment

### Prepare Inventory

Edit `inventory/hosts.ini`:

```ini
[monitoring_servers]
monitor1 ansible_host=192.168.1.10

[automation_servers]
auto1 ansible_host=192.168.1.11

[analytics_servers]
analytics1 ansible_host=192.168.1.12

[all:vars]
ansible_user=ubuntu
ansible_become=yes
```

### Run Playbooks

```bash
# Install all software on all servers
ansible-playbook -i inventory/hosts.ini playbooks/install_all_software.yml

# Install only monitoring tools
ansible-playbook -i inventory/hosts.ini playbooks/install_monitoring_tools.yml

# Install only automation tools
ansible-playbook -i inventory/hosts.ini playbooks/install_automation_tools.yml

# Dry run (check mode)
ansible-playbook -i inventory/hosts.ini playbooks/install_all_software.yml --check

# Limit to specific hosts
ansible-playbook -i inventory/hosts.ini playbooks/install_all_software.yml --limit monitor1
```

### Custom Variables

Create a variables file `vars/custom.yml`:

```yaml
install_monitoring: true
install_automation: true
install_analytics: false
install_data_infrastructure: true
```

Run with custom variables:

```bash
ansible-playbook -i inventory/hosts.ini playbooks/install_all_software.yml -e @vars/custom.yml
```

---

## Post-Installation Configuration

### Security Hardening

1. **Change Default Passwords**
   ```bash
   # For each service, change admin passwords immediately
   # Check SOFTWARE_CATALOG.md for default credentials
   ```

2. **Enable Firewall**
   ```bash
   sudo ufw allow 22/tcp
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   # Add specific service ports as needed
   sudo ufw enable
   ```

3. **Configure SSL/TLS**
   ```bash
   # Use Let's Encrypt for free SSL certificates
   sudo apt install certbot
   sudo certbot certonly --standalone -d your-domain.com
   ```

### Service Management

#### Systemd Services

```bash
# Check status
sudo systemctl status SERVICE_NAME

# Start/Stop/Restart
sudo systemctl start SERVICE_NAME
sudo systemctl stop SERVICE_NAME
sudo systemctl restart SERVICE_NAME

# Enable/Disable autostart
sudo systemctl enable SERVICE_NAME
sudo systemctl disable SERVICE_NAME

# View logs
sudo journalctl -u SERVICE_NAME -f
```

#### Docker Services

```bash
# View running containers
docker ps

# View all containers
docker ps -a

# View logs
docker logs -f CONTAINER_NAME

# Restart container
docker restart CONTAINER_NAME

# Stop container
docker stop CONTAINER_NAME

# Remove container
docker rm CONTAINER_NAME
```

---

## Troubleshooting

### Common Issues

#### Port Already in Use

```bash
# Find process using port
sudo lsof -i :PORT_NUMBER

# Or
sudo netstat -tulpn | grep PORT_NUMBER

# Kill process
sudo kill -9 PID
```

#### Service Won't Start

```bash
# Check logs
sudo journalctl -u SERVICE_NAME -n 50

# Or for Docker
docker logs CONTAINER_NAME

# Check system resources
free -h
df -h
```

#### Permission Denied

```bash
# Fix ownership
sudo chown -R $USER:$USER /path/to/directory

# Fix permissions
sudo chmod -R 755 /path/to/directory
```

#### Docker Issues

```bash
# Restart Docker daemon
sudo systemctl restart docker

# Clean up Docker
docker system prune -a

# View Docker logs
sudo journalctl -u docker -n 50
```

### Getting Help

1. **Check Logs**
   - Installation logs: `/tmp/*_install_*.log`
   - Service logs: `sudo journalctl -u SERVICE_NAME`
   - Docker logs: `docker logs CONTAINER_NAME`

2. **Documentation**
   - [SOFTWARE_CATALOG.md](SOFTWARE_CATALOG.md) - Complete software reference
   - [docker/compose/README.md](docker/compose/README.md) - Docker Compose guide
   - Individual script headers contain usage information

3. **Community Support**
   - GitHub Issues: Report problems
   - Check official documentation for each tool

---

## Summary

You now have access to installation methods for 55+ software packages:

- **4 Monitoring Tools**: OpenNMS, Zabbix, Web Check, Prometheus/Grafana
- **6 Automation Platforms**: Leon, Automatisch, StackStorm, Eonza, Kibitzr, n8n
- **10 Analytics Tools**: PostHog, Plausible, Metabase, Umami, Superset, Aptabase, Mixpost, OWA
- **4 Data Infrastructure**: Kafka, Cassandra, Parseable, RudderStack
- **8 AI/ML Tools**: Langfuse, LangSmith, LangChain, LangGraph, LocalAI, AnythingLLM, Matchering
- **Gaming**: LinuxGSM
- **Dashboards**: Homepage, OliveTin
- **Security**: Bitwarden
- **CMS**: WordPress, Ghost, Hugo
- **Frameworks**: Next.js, Astro
- **Development**: TypeScript LSP, Python LSP, Aider
- **AI Tools**: Gemini CLI, Cline, Codex CLI, Kimi CLI, Crush
- **System Tools**: vstat, vtstat, statpak

Choose your preferred installation method and start deploying!

For the complete software catalog with detailed information, see [SOFTWARE_CATALOG.md](SOFTWARE_CATALOG.md).
