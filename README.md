# CloudCurio Infrastructure

A comprehensive infrastructure-as-code repository featuring Ansible roles and playbooks for deploying and managing 100+ DevOps tools.

## Overview

This repository provides a complete automation solution for setting up and managing a wide range of DevOps tools and services. Whether you're setting up a new development environment or managing production infrastructure, CloudCurio Infrastructure has you covered.

## Features

- **100+ DevOps Tools**: Comprehensive Ansible roles for popular DevOps tools across multiple categories
- **Infrastructure as Code**: Manage your infrastructure declaratively using Ansible
- **Modular Design**: Each tool is implemented as a separate, reusable role
- **Production Ready**: Battle-tested configurations for reliable deployments
- **Multi-Platform Support**: Compatible with various Linux distributions

## Quick Start

### Prerequisites

- Ansible 2.9 or higher
- SSH access to target hosts
- Python 3.6 or higher
- Ubuntu/Debian-based Linux systems

### Fast Setup

**Option 1: Automated Ansible Deployment (Recommended)**
```bash
git clone https://github.com/cbwinslow/cloudcurio-infra.git
cd cloudcurio-infra

# Test connectivity to ZeroTier nodes
ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml

# Deploy full infrastructure
ansible-playbook -i inventory/hosts.ini playbooks/master_infrastructure_setup.yml
```

**Option 2: Manual Installation with Scripts**
```bash
cd cloudcurio-infra

# Run interactive installer
bash scripts/master_installer.sh

# Or install specific components
bash scripts/installers/container/install_docker.sh
bash scripts/installers/monitoring/install_monitoring_stack.sh
bash scripts/installers/ai-ml/install_ai_stack.sh
```

See [QUICKSTART.md](QUICKSTART.md) for detailed instructions.

## Documentation

- **[Quick Start Guide](QUICKSTART.md)** - Get up and running quickly
- **[Infrastructure Guide](INFRASTRUCTURE_GUIDE.md)** - Comprehensive infrastructure documentation
- **[DevOps Tools Reference](DEVOPS_TOOLS_REFERENCE.md)** - Complete list of supported tools organized by category
- **[Contributing Guidelines](CONTRIBUTING.md)** - How to contribute to this project
- **[Ansible Roles](roles/)** - Browse available roles organized by category
- **[Playbooks](playbooks/)** - Example playbooks including network tests and master setup
- **[Installer Scripts](scripts/installers/)** - Standalone installation scripts for quick setup

## Repository Structure

```
cloudcurio-infra/
├── ansible/              # Ansible-specific configurations
├── playbooks/            # Ansible playbooks
│   ├── test_network_connectivity.yml  # ZeroTier network tests
│   ├── master_infrastructure_setup.yml # Complete infrastructure deployment
│   └── ...
├── roles/                # Ansible roles organized by category
│   ├── networking/       # ZeroTier, AutoSSH, SSH Bastion, Cloudflare Tunnels
│   ├── monitoring/       # Prometheus, Grafana, Loki, Wazuh, Suricata
│   ├── security/         # Security tools and SIEM
│   ├── container/        # Docker, Docker Compose
│   ├── automation/       # SaltStack, n8n, Flowise
│   ├── ai-ml/           # AnythingLLM, LocalAI, Langfuse, Agent-Zero, MCP
│   ├── databases/        # Qdrant, Weaviate, OpenSearch
│   ├── infrastructure/   # Teleport, Chezmoi, systemd services
│   ├── web/             # Apache, Nginx, Caddy
│   └── development/      # Development tools
├── inventory/            # Inventory files with ZeroTier IPs
├── group_vars/           # Group variables including ZeroTier mappings
├── templates/            # Configuration templates
│   ├── systemd/         # Systemd service templates
│   └── cron/            # Cron job templates
├── scripts/              # Utility and installer scripts
│   ├── master_installer.sh  # Interactive installer
│   └── installers/      # Category-specific installers
│       ├── networking/
│       ├── monitoring/
│       ├── security/
│       ├── container/
│       ├── automation/
│       ├── ai-ml/
│       ├── infrastructure/
│       └── web/
├── terraform/            # Terraform configurations
├── docker/               # Docker configurations
├── caddy/                # Caddy configurations
└── nginx/                # Nginx configurations
```

## Categories of Tools

Our DevOps tools are organized into the following categories with dedicated Ansible roles and installer scripts:

- **Networking & VPN**: ZeroTier, AutoSSH, SSH Bastion, Cloudflare Tunnels
- **CI/CD & Automation**: Jenkins, GitLab CI, GitHub Actions, CircleCI, SaltStack, n8n, Flowise
- **Container & Orchestration**: Docker, Kubernetes, Podman, containerd
- **Monitoring & Observability**: Prometheus, Grafana, Loki, ELK Stack, Datadog, Wazuh, Suricata
- **Infrastructure as Code**: Terraform, Ansible, Packer, Vagrant
- **Security & Compliance**: Vault, SonarQube, Trivy, OWASP tools, Wazuh SIEM
- **AI & Machine Learning**: AnythingLLM, LocalAI, Langfuse, Agent-Zero, MCP Servers
- **Vector Databases**: Qdrant, Weaviate, OpenSearch
- **Version Control & Collaboration**: Git, GitLab, GitHub, Gitea
- **Database & Storage**: PostgreSQL, MySQL, MongoDB, Redis
- **Web Servers & Proxies**: Nginx, Apache, Caddy, HAProxy
- **Cloud Platforms**: AWS, Azure, GCP, DigitalOcean tools
- **Development Tools**: IDEs, Language runtimes, Build tools, Chezmoi

For a complete list, see the [DevOps Tools Reference](DEVOPS_TOOLS_REFERENCE.md).

## Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- How to submit issues
- How to propose new features
- Code style and standards
- Pull request process
- Code of conduct

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/cbwinslow/cloudcurio-infra/issues)
- **Discussions**: [GitHub Discussions](https://github.com/cbwinslow/cloudcurio-infra/discussions)

## Acknowledgments

Thanks to all contributors who have helped make this project possible!
