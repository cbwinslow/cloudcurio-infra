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

### Basic Usage

1. Clone this repository:
```bash
git clone https://github.com/cbwinslow/cloudcurio-infra.git
cd cloudcurio-infra
```

2. Configure your inventory:
```bash
cp inventory/hosts.example inventory/hosts
# Edit inventory/hosts with your target hosts
```

3. Run a playbook:
```bash
ansible-playbook -i inventory/hosts site.yml
```

## Documentation

- **[DevOps Tools Reference](DEVOPS_TOOLS_REFERENCE.md)** - Complete list of supported tools organized by category
- **[Contributing Guidelines](CONTRIBUTING.md)** - How to contribute to this project
- **[Ansible Roles](roles/)** - Browse available roles
- **[Playbooks](playbooks/)** - Example playbooks

## Repository Structure

```
cloudcurio-infra/
├── ansible/              # Ansible-specific configurations
├── playbooks/            # Ansible playbooks
├── roles/                # Ansible roles for each tool
├── inventory/            # Inventory files
├── group_vars/           # Group variables
├── templates/            # Configuration templates
├── scripts/              # Utility scripts
├── terraform/            # Terraform configurations
├── docker/               # Docker configurations
├── caddy/                # Caddy configurations
└── nginx/                # Nginx configurations
```

## Categories of Tools

Our DevOps tools are organized into the following categories:

- **CI/CD & Automation**: Jenkins, GitLab CI, GitHub Actions, CircleCI, and more
- **Container & Orchestration**: Docker, Kubernetes, Podman, containerd
- **Monitoring & Observability**: Prometheus, Grafana, ELK Stack, Datadog
- **Infrastructure as Code**: Terraform, Ansible, Packer, Vagrant
- **Security & Compliance**: Vault, SonarQube, Trivy, OWASP tools
- **Version Control & Collaboration**: Git, GitLab, GitHub, Gitea
- **Database & Storage**: PostgreSQL, MySQL, MongoDB, Redis
- **Web Servers & Proxies**: Nginx, Apache, Caddy, HAProxy
- **Cloud Platforms**: AWS, Azure, GCP, DigitalOcean tools
- **Development Tools**: IDEs, Language runtimes, Build tools

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
