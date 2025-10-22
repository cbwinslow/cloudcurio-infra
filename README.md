# CloudCurio Infrastructure - DevOps Tools Monorepo

<div align="center">

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Ansible](https://img.shields.io/badge/ansible-2.9%2B-red.svg)
![Python](https://img.shields.io/badge/python-3.11%2B-blue.svg)
![Tools](https://img.shields.io/badge/tools-100%2B-green.svg)

**A comprehensive, automated installer for 100+ DevOps tools**

[Quick Start](#-quick-start) • [Documentation](#-documentation) • [TUI Installer](#-interactive-installer-tui) • [Tools List](#-available-tools) • [Contributing](#-contributing)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Interactive Installer (TUI)](#-interactive-installer-tui)
- [Available Tools](#-available-tools)
- [Installation Methods](#-installation-methods)
- [Configuration](#-configuration)
- [Usage Examples](#-usage-examples)
- [Testing & Validation](#-testing--validation)
- [Utilities & Helper Scripts](#-utilities--helper-scripts)
- [Troubleshooting](#-troubleshooting)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

CloudCurio Infrastructure is a **monorepo** containing Ansible automation for deploying a complete DevOps environment. Whether you're setting up a development workstation, a CI/CD pipeline, or a production monitoring stack, this repository provides everything you need in one place.

**What makes this special:**
- 🚀 **One-command installation** for complex tool stacks
- 🎨 **Interactive TUI** for guided installation
- 🔍 **View current setup** - see what's already installed
- ✅ **Pre/post validation** - verify installation success
- 📦 **77 Ansible roles** covering 100+ tools
- 🏷️ **Tagged deployments** - install only what you need
- 🔐 **Vault support** for secure credential management
- 📊 **Comprehensive testing** framework included

---

## ✨ Features

### Core Features
- **Comprehensive Coverage**: 100+ tools across all DevOps categories
- **Idempotent Operations**: Safe to run multiple times
- **Selective Installation**: Use tags to install specific tools or categories
- **Configuration Management**: Centralized configuration with override support
- **Automated Testing**: Built-in validation and health checks
- **Documentation**: Extensive guides, examples, and troubleshooting

### Usability Features
- **Interactive TUI**: Terminal UI for easy tool selection and installation
- **Status Viewer**: Check what's currently installed on your system
- **Pre-flight Checks**: Validate system requirements before installation
- **Post-install Verification**: Automatic testing after deployment
- **Rollback Support**: Revert changes if needed
- **Progress Tracking**: Visual feedback during installations

### Advanced Features
- **Ansible Vault Integration**: Secure credential storage
- **Custom Variable Overrides**: Per-environment configuration
- **Multi-host Deployment**: Install across multiple machines
- **Parallel Execution**: Speed up installations
- **Health Monitoring**: Check service status
- **Backup/Restore**: Protect your configurations

---

## 📋 Prerequisites

### System Requirements
- **Operating System**: Ubuntu 20.04+, Debian 10+, or compatible Linux distribution
- **Python**: 3.8 or higher
- **Ansible**: 2.9 or higher
- **Disk Space**: Minimum 10GB free (more for databases and AI tools)
- **Memory**: Minimum 4GB RAM (8GB+ recommended for AI tools)
- **Network**: Internet connectivity for package downloads

### Required Packages
```bash
# Install Python and pip
sudo apt update
sudo apt install -y python3 python3-pip python3-venv git

# Install Ansible
pip3 install ansible

# Optional: Install Ansible collections
ansible-galaxy collection install community.docker
ansible-galaxy collection install community.general
```

---

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/cbwinslow/cloudcurio-infra.git
cd cloudcurio-infra
```

### 2. Run System Check
```bash
./scripts/check-requirements.sh
```

### 3. Choose Your Installation Method

#### Option A: Interactive TUI (Recommended for beginners)
```bash
python3 tui/installer.py
```

#### Option B: Command-line (Advanced users)
```bash
# Install everything
ansible-playbook -i inventory/hosts.ini sites.yml

# Install specific categories
ansible-playbook -i inventory/hosts.ini sites.yml --tags "database,monitoring"

# Install specific tools
ansible-playbook -i inventory/hosts.ini sites.yml --tags "docker,python,grafana"
```

#### Option C: Use Installation Wizard
```bash
./scripts/install-wizard.sh
```

### 4. Verify Installation
```bash
./scripts/verify-installation.sh
```

---

## 🎨 Interactive Installer (TUI)

The Terminal User Interface provides an easy way to select and install tools without memorizing Ansible commands.

### Features
- **Browse by Category**: Navigate through tool categories
- **Multi-select**: Choose multiple tools at once
- **View Details**: See tool descriptions, ports, and requirements
- **Current Status**: See what's already installed
- **Installation Progress**: Real-time feedback
- **Error Handling**: Clear error messages and recovery options

### Usage
```bash
# Start the interactive installer
python3 tui/installer.py

# View current installation status
python3 tui/installer.py --status

# Uninstall tools
python3 tui/installer.py --uninstall
```

### Screenshots
![TUI Main Screen](docs/screenshots/tui-main.png)
![TUI Installation](docs/screenshots/tui-install.png)

---

## 🛠️ Available Tools

<details>
<summary><b>Programming Languages & Runtimes (4 tools)</b></summary>

- **Python 3.11+** - Python programming language with pip, virtualenv, poetry
- **UV** - Next-generation Python package manager
- **Node.js 20** - JavaScript runtime with npm, yarn, pnpm
- **PHP 8+** - PHP with common extensions and Composer

</details>

<details>
<summary><b>Container & Orchestration (3 tools)</b></summary>

- **Docker** - Container platform
- **Docker Compose** - Multi-container orchestration
- **Podman** - Daemonless container engine

</details>

<details>
<summary><b>Databases (6 tools)</b></summary>

- **PostgreSQL 15** - Relational database
- **MySQL 8.0** - Relational database
- **ClickHouse** - Columnar database for analytics
- **InfluxDB 2.x** - Time-series database
- **TimescaleDB** - PostgreSQL extension for time-series
- **VictoriaMetrics** - Fast time-series database

</details>

<details>
<summary><b>Web Servers & Reverse Proxies (4 tools)</b></summary>

- **Nginx** - High-performance web server
- **Apache2** - Apache HTTP Server
- **Caddy** - Modern web server with automatic HTTPS
- **Traefik** - Cloud-native reverse proxy

</details>

<details>
<summary><b>AI/ML Tools (5 tools)</b></summary>

- **Ollama** - Run LLMs locally (Llama2, Mistral, etc.)
- **LocalAI** - OpenAI-compatible local API
- **OpenWebUI** - Web interface for LLMs
- **Flowise** - LangChain visual builder
- **Haystack** - NLP framework

</details>

<details>
<summary><b>Monitoring & Logging (8 tools)</b></summary>

- **Grafana** - Visualization and dashboards
- **Prometheus** - Metrics collection and alerting
- **Loki** - Log aggregation
- **Elasticsearch** - Search and analytics engine
- **OpenSearch** - Community-driven search engine
- **Graylog** - Enterprise log management
- **Logfire** - Modern observability
- **Graphite** - Metrics monitoring

</details>

<details>
<summary><b>Infrastructure Tools (4 tools)</b></summary>

- **Terraform** - Infrastructure as Code
- **Pulumi** - Modern Infrastructure as Code
- **Consul** - Service mesh and discovery
- **Kong** - API Gateway

</details>

<details>
<summary><b>Authentication & Security (3 tools)</b></summary>

- **Keycloak** - Identity and access management
- **Bitwarden** - Password manager (Vaultwarden)
- **Vault** - Secrets management

</details>

<details>
<summary><b>Development Environments (9 tools)</b></summary>

- **VS Code** - Microsoft Visual Studio Code
- **Cursor** - AI-powered code editor
- **Zed** - High-performance editor
- **Windsurf** - Cloud IDE
- **VS Code Server** - Browser-based VS Code
- **Gitpod** - Cloud development environment
- **DevPod** - Dev environment manager
- **DevBox** - Portable development environments
- **DevContainer** - Development containers

</details>

<details>
<summary><b>Networking & VPN (4 tools)</b></summary>

- **Tailscale** - Zero-config VPN
- **ZeroTier** - Software-defined networking
- **WireGuard** - Fast VPN protocol
- **Cloudflared** - Cloudflare tunnels

</details>

<details>
<summary><b>Collaboration & Cloud Storage (4 tools)</b></summary>

- **Nextcloud** - Self-hosted cloud storage
- **OwnCloud** - Enterprise file sharing
- **GitLab** - Complete DevOps platform
- **Gitea** - Lightweight Git service

</details>

<details>
<summary><b>AI Agent Frameworks (7 tools)</b></summary>

- **Agent-Zero** - Autonomous AI agent framework
- **AnythingLLM** - All-in-one LLM toolkit
- **Jan** - Desktop AI assistant
- **Dyad** - Multi-agent system
- **LM Studio** - Local LLM runner
- **LocalRecall** - Memory system for agents
- **LocalAGI** - Local AGI framework

</details>

<details>
<summary><b>Search & Web Scraping (4 tools)</b></summary>

- **SearXNG** - Privacy-respecting metasearch
- **Exa** - Modern ls replacement
- **Firecrawl** - Web scraping framework
- **Crawl4AI** - AI-powered web crawler

</details>

<details>
<summary><b>Streaming & Messaging (2 tools)</b></summary>

- **Kafka** - Distributed streaming platform
- **N8N** - Workflow automation

</details>

<details>
<summary><b>Remote Access (3 tools)</b></summary>

- **Guacamole** - Clientless remote desktop
- **OpenSSH** - Secure shell server
- **Cockpit** - Web-based server management

</details>

<details>
<summary><b>Additional Tools (8 tools)</b></summary>

- **Supabase** - Open-source Firebase alternative
- **Prisma** - Next-generation ORM
- **Pydantic** - Data validation for Python
- **Next.js** - React framework
- **Uptime Kuma** - Uptime monitoring
- **OpenRouter SDK** - Multi-LLM API client
- **Gemini CLI** - Google Gemini command-line tool
- **Qodo** - AI code quality assistant

</details>

[View detailed tool descriptions →](DEVOPS_TOOLS_README.md)

---

## 📦 Installation Methods

### Method 1: Interactive TUI (Recommended)
Perfect for first-time users and visual learners.

```bash
python3 tui/installer.py
```

### Method 2: Command-Line Ansible
For automation and scripting.

```bash
# Install all tools
ansible-playbook -i inventory/hosts.ini sites.yml

# Install by category
ansible-playbook -i inventory/hosts.ini sites.yml --tags "database"

# Install specific tools
ansible-playbook -i inventory/hosts.ini sites.yml --tags "docker,grafana"
```

### Method 3: Installation Wizard
Guided command-line wizard.

```bash
./scripts/install-wizard.sh
```

### Method 4: Pre-configured Stacks
One-command installation for common scenarios.

```bash
# Development workstation
./scripts/install-stack.sh dev-workstation

# Monitoring server
./scripts/install-stack.sh monitoring

# AI/ML environment
./scripts/install-stack.sh ai-ml

# Full stack
./scripts/install-stack.sh full-stack
```

---

## ⚙️ Configuration

### Basic Configuration
Edit `group_vars/devops.yml` to customize installations:

```yaml
# Python configuration
python_version: "3.11"
python_packages:
  - pip
  - virtualenv
  - custom-package

# Docker configuration
docker_users:
  - your-username

# Grafana configuration
grafana_admin_password: "{{ vault_grafana_password }}"
grafana_port: 3002
```

### Secure Secrets with Ansible Vault
```bash
# Create vault file
ansible-vault create group_vars/vault.yml

# Add sensitive variables
# vault_grafana_password: SecurePassword123
# vault_database_password: AnotherSecurePass

# Run playbook with vault
ansible-playbook -i inventory/hosts.ini sites.yml --ask-vault-pass
```

### Per-Environment Configuration
Create environment-specific variable files:

```bash
group_vars/
├── all.yml           # Global defaults
├── devops.yml        # DevOps tools defaults
├── production.yml    # Production overrides
├── staging.yml       # Staging overrides
└── development.yml   # Development overrides
```

---

## 💡 Usage Examples

### Essential Development Setup
```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "python,nodejs,docker,postgresql,vscode,git"
```

### AI/ML Research Environment
```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "python,docker,ollama,localai,openwebui,flowise,haystack"
```

### Monitoring & Observability Stack
```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "prometheus,grafana,loki,elasticsearch,alertmanager"
```

### Web Development Stack
```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "nodejs,php,mysql,nginx,caddy,nextjs"
```

### Complete DevOps Platform
```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "docker,kubernetes,gitlab,jenkins,prometheus,grafana"
```

[More examples →](QUICK_REFERENCE.md)

---

## ✅ Testing & Validation

### Pre-Installation Checks
```bash
# Check system requirements
./scripts/check-requirements.sh

# Validate Ansible configuration
./scripts/validate-config.sh

# Test network connectivity
./scripts/test-connectivity.sh
```

### Post-Installation Verification
```bash
# Verify all installations
./scripts/verify-installation.sh

# Test specific category
./scripts/verify-installation.sh --category database

# Test specific tool
./scripts/verify-installation.sh --tool grafana
```

### Automated Testing
```bash
# Run all tests
./scripts/run-tests.sh

# Run role-specific tests
./scripts/test-role.sh docker

# Run integration tests
./scripts/run-integration-tests.sh
```

### Health Checks
```bash
# Check service status
./scripts/health-check.sh

# Check port availability
./scripts/check-ports.sh

# Verify configurations
./scripts/verify-configs.sh
```

---

## 🔧 Utilities & Helper Scripts

### System Management
- `scripts/check-requirements.sh` - Verify system prerequisites
- `scripts/health-check.sh` - Check service health
- `scripts/view-status.sh` - View installation status
- `scripts/manage-services.sh` - Start/stop/restart services

### Installation Tools
- `scripts/install-wizard.sh` - Interactive installation wizard
- `scripts/install-stack.sh` - Install pre-configured stacks
- `scripts/uninstall.sh` - Remove installed tools
- `scripts/update-tools.sh` - Update installed tools

### Testing & Validation
- `scripts/verify-installation.sh` - Verify installations
- `scripts/run-tests.sh` - Run test suite
- `scripts/validate-config.sh` - Validate configuration files
- `scripts/test-connectivity.sh` - Test network connectivity

### Backup & Recovery
- `scripts/backup-configs.sh` - Backup configurations
- `scripts/restore-configs.sh` - Restore from backup
- `scripts/export-config.sh` - Export current configuration
- `scripts/rollback.sh` - Rollback to previous state

### Utilities
- `scripts/list-tools.sh` - List all available tools
- `scripts/show-ports.sh` - Show port assignments
- `scripts/generate-docs.sh` - Generate documentation
- `scripts/cleanup.sh` - Clean up temporary files

---

## 🐛 Troubleshooting

### Common Issues

#### Ansible Connection Issues
```bash
# Test connection to hosts
ansible -i inventory/hosts.ini all -m ping

# Check SSH configuration
./scripts/test-connectivity.sh
```

#### Permission Denied Errors
```bash
# Ensure proper sudo access
ansible-playbook -i inventory/hosts.ini sites.yml --ask-become-pass

# Check user permissions
./scripts/check-permissions.sh
```

#### Port Conflicts
```bash
# Check port availability
./scripts/check-ports.sh

# View default ports
./scripts/show-ports.sh

# Customize ports in group_vars/devops.yml
```

#### Docker Issues
```bash
# Verify Docker installation
docker --version

# Check Docker daemon
sudo systemctl status docker

# Test Docker permissions
docker ps
```

[Full troubleshooting guide →](docs/TROUBLESHOOTING.md)

---

## 📚 Documentation

### Core Documentation
- **[README.md](README.md)** - This file
- **[DEVOPS_TOOLS_README.md](DEVOPS_TOOLS_README.md)** - Comprehensive tool documentation
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick command reference
- **[KNOWN_ISSUES.md](KNOWN_ISSUES.md)** - Known issues and workarounds

### Guides
- **[INSTALLATION_GUIDE.md](docs/INSTALLATION_GUIDE.md)** - Detailed installation instructions
- **[CONFIGURATION_GUIDE.md](docs/CONFIGURATION_GUIDE.md)** - Configuration reference
- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Troubleshooting guide
- **[BEST_PRACTICES.md](docs/BEST_PRACTICES.md)** - Best practices and patterns

### Development
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines
- **[DEVELOPMENT.md](docs/DEVELOPMENT.md)** - Development setup
- **[TESTING.md](docs/TESTING.md)** - Testing guide
- **[ROLE_DEVELOPMENT.md](docs/ROLE_DEVELOPMENT.md)** - Creating new roles

### API & Reference
- **[ANSIBLE_REFERENCE.md](docs/ANSIBLE_REFERENCE.md)** - Ansible usage reference
- **[VARIABLES.md](docs/VARIABLES.md)** - Variable reference
- **[TAGS.md](docs/TAGS.md)** - Tag reference
- **[API.md](docs/API.md)** - API documentation for scripts

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Quick Start for Contributors
```bash
# Fork and clone
git clone https://github.com/yourusername/cloudcurio-infra.git
cd cloudcurio-infra

# Create feature branch
git checkout -b feature/your-feature

# Make changes and test
./scripts/run-tests.sh

# Commit and push
git commit -m "Add: your feature"
git push origin feature/your-feature
```

### Areas for Contribution
- 🐛 Bug fixes
- ✨ New tool roles
- 📝 Documentation improvements
- 🧪 Test coverage
- 🎨 TUI enhancements
- 🔧 Utility scripts
- 🌍 Internationalization

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Ansible community for the excellent automation framework
- All the amazing open-source projects included in this repository
- Contributors and users who provide feedback and improvements

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/cbwinslow/cloudcurio-infra/issues)
- **Discussions**: [GitHub Discussions](https://github.com/cbwinslow/cloudcurio-infra/discussions)
- **Documentation**: [Full Documentation](docs/)

---

<div align="center">

**Made with ❤️ by the CloudCurio team**

[⬆ Back to top](#cloudcurio-infrastructure---devops-tools-monorepo)

</div>
