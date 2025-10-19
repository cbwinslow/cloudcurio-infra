# DevOps Tools Ansible Configuration

This repository contains Ansible roles and playbooks for deploying a comprehensive DevOps environment with 100+ tools commonly used in modern infrastructure.

## Overview

The configuration includes roles for:

### Programming Languages & Runtimes
- **python** - Python 3.x with pip, virtualenv, poetry
- **uv** - Modern Python package manager
- **nodejs** - Node.js with npm, yarn, pnpm
- **php** - PHP with common extensions

### Container & Orchestration
- **docker** - Docker Engine
- **docker-compose** - Docker Compose
- **podman** - Podman container runtime

### Databases
- **postgresql** - PostgreSQL relational database
- **mysql** - MySQL/MariaDB
- **clickhouse** - ClickHouse columnar database
- **influxdb** - InfluxDB time-series database
- **timescaledb** - TimescaleDB (PostgreSQL extension)
- **victoriametrics** - VictoriaMetrics time-series database

### Web Servers & Reverse Proxies
- **nginx** - Nginx web server (already exists)
- **apache2** - Apache2 web server
- **caddy** - Caddy web server (already exists)
- **traefik** - Traefik reverse proxy

### AI/ML Tools
- **ollama** - Run LLMs locally
- **localai** - OpenAI alternative
- **openwebui** - Web UI for LLMs
- **flowise** - LangChain visual builder
- **haystack** - NLP framework

### Monitoring & Logging
- **grafana** - Visualization and analytics
- **prometheus** - Metrics collection
- **loki** - Log aggregation
- **elasticsearch** - Search and analytics
- **opensearch** - OpenSearch (Elasticsearch fork)
- **graylog** - Log management
- **logfire** - Modern logging
- **graphite** - Metrics monitoring

### Infrastructure Tools
- **terraform** - Infrastructure as Code
- **pulumi** - Infrastructure as Code (multi-cloud)
- **consul** - Service mesh and discovery
- **kong** - API Gateway
- **vault** - Secrets management (already exists)

### Authentication & Security
- **keycloak** - Identity and access management
- **bitwarden** - Password manager (Vaultwarden)

### Development Environments
- **vscode** - Visual Studio Code
- **cursor** - AI-powered IDE
- **zed** - High-performance editor
- **windsurf** - Cloud IDE
- **vscode-server** - VS Code in browser
- **gitpod** - Cloud development environment
- **devpod** - Dev environment manager
- **devbox** - Portable dev environments
- **devcontainer** - Development containers

### Networking & VPN
- **tailscale** - Zero-config VPN
- **zerotier** - Software-defined networking
- **wireguard** - Fast VPN protocol
- **cloudflared** - Cloudflare tunnels

### Collaboration & Cloud Storage
- **nextcloud** - Self-hosted cloud storage
- **owncloud** - Cloud storage platform
- **gitlab** - Complete DevOps platform
- **gitea** - Lightweight Git service

### AI Agent Frameworks
- **agent-zero** - AI agent framework
- **anythingllm** - All-in-one LLM toolkit
- **jan** - Desktop AI assistant
- **dyad** - AI agent system
- **lm-studio** - Local LLM runner
- **localrecall** - Local memory system
- **localagi** - Local AGI framework

### Search & Web Scraping
- **searxng** - Privacy-respecting search
- **exa** - Modern ls replacement
- **firecrawl** - Web scraping framework
- **crawl4ai** - AI-powered web crawler

### Streaming & Messaging
- **kafka** - Distributed streaming
- **n8n** - Workflow automation

### Remote Access
- **guacamole** - Clientless remote desktop
- **openssh** - OpenSSH server
- **cockpit** - Web-based server management

### Additional Tools
- **supabase** - Open-source Firebase alternative
- **prisma** - Next-generation ORM
- **pydantic** - Data validation library
- **nextjs** - React framework
- **uptime-kuma** - Uptime monitoring
- **openrouter-sdk** - OpenRouter API SDK
- **gemini-cli** - Google Gemini CLI
- **qodo** - AI code assistant

## Usage

### Run All Configurations

```bash
ansible-playbook -i inventory/hosts.ini sites.yml
```

### Run Specific Roles with Tags

```bash
# Install only Python tools
ansible-playbook -i inventory/hosts.ini sites.yml --tags "python"

# Install all databases
ansible-playbook -i inventory/hosts.ini sites.yml --tags "database"

# Install all AI tools
ansible-playbook -i inventory/hosts.ini sites.yml --tags "ai"

# Install monitoring stack
ansible-playbook -i inventory/hosts.ini sites.yml --tags "monitoring,logging"
```

### Available Tag Categories

- `lang` - Programming languages
- `container` - Container runtimes
- `database` - Database systems
- `webserver` - Web servers
- `proxy` - Reverse proxies
- `ai` - AI/ML tools
- `monitoring` - Monitoring tools
- `logging` - Logging systems
- `iac` - Infrastructure as Code
- `auth` - Authentication systems
- `ide` - Development environments
- `vpn` - VPN and networking
- `cloud` - Cloud storage
- `git` - Git services
- `agent` - AI agent frameworks
- `search` - Search engines
- `scraping` - Web scraping
- `streaming` - Message streaming
- `remote` - Remote access

## Configuration

### Inventory

The inventory is defined in `inventory/hosts.ini`. Key groups:

- `cloudcurio` - Base infrastructure nodes
- `devops` - Nodes for DevOps tools installation
- `openstack_controllers` - OpenStack controllers
- `vault_servers` - Vault secret management

### Group Variables

Configuration variables are in `group_vars/`:

- `all.yml` - Global variables
- `devops.yml` - DevOps tool specific variables

### Customization

Edit `group_vars/devops.yml` to customize:

- Software versions
- Port numbers
- Admin credentials
- Feature toggles
- Service configurations

Example:

```yaml
# Customize Python version
python_version: "3.11"

# Add Python packages
python_packages:
  - pip
  - virtualenv
  - custom-package

# Configure Grafana
grafana_admin_user: admin
grafana_admin_password: "{{ vault_grafana_password }}"
grafana_port: 3002
```

## Security Notes

1. **Default Passwords**: Many roles use default passwords (`changeme`). Replace these with secure passwords, preferably using Ansible Vault.

2. **Sensitive Variables**: Store sensitive data in Ansible Vault:
   ```bash
   ansible-vault create group_vars/vault.yml
   ```

3. **Firewall**: Set `enable_firewall: true` in group_vars to enable UFW firewall rules.

4. **SSH Keys**: The OpenSSH role enables password authentication. For production, use key-based authentication only.

## Requirements

- Ansible 2.9+
- Target hosts running Ubuntu 20.04+ or Debian 10+
- Sudo access on target hosts
- Internet connectivity for package downloads

## Directory Structure

```
.
├── ansible.cfg           # Ansible configuration
├── sites.yml            # Master playbook
├── inventory/
│   └── hosts.ini        # Inventory file
├── group_vars/
│   ├── all.yml         # Global variables
│   └── devops.yml      # DevOps tool variables
├── roles/
│   ├── python/         # Python role
│   ├── docker/         # Docker role
│   ├── ...             # 100+ other roles
│   └── vault/          # Vault role
└── playbooks/
    ├── dev_env_bootstrap.yml
    └── onboard_cbwdellr720.yml
```

## Testing

Validate playbook syntax:

```bash
ansible-playbook --syntax-check sites.yml
```

Test with check mode (dry run):

```bash
ansible-playbook -i inventory/hosts.ini sites.yml --check
```

## Troubleshooting

### Role Not Found

Ensure you're running playbooks from the repository root:

```bash
cd /path/to/cloudcurio-infra
ansible-playbook -i inventory/hosts.ini sites.yml
```

### Docker Roles Failing

Ensure Docker is installed before running Docker-based roles:

```bash
ansible-playbook -i inventory/hosts.ini sites.yml --tags "docker" --limit devops
```

### Port Conflicts

Check `group_vars/devops.yml` for port configurations and adjust as needed.

## Contributing

When adding new roles:

1. Create role structure: `roles/role-name/{tasks,defaults,handlers,templates,files}/`
2. Add tasks in `tasks/main.yml`
3. Add defaults in `defaults/main.yml`
4. Add to `sites.yml` with appropriate tags
5. Update this README

## License

This configuration is provided as-is for use in the CloudCurio infrastructure.
