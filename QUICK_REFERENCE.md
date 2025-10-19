# Quick Reference - DevOps Tools Installation

## Quick Start

Install everything:
```bash
ansible-playbook -i inventory/hosts.ini sites.yml
```

## Common Use Cases

### Essential Development Stack
```bash
# Programming languages, git, docker, databases
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "python,nodejs,docker,postgresql,mysql,git"
```

### AI/ML Development Environment
```bash
# Install AI tools and dependencies
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "python,docker,ollama,localai,openwebui,flowise"
```

### Monitoring & Observability Stack
```bash
# Full monitoring setup
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "prometheus,grafana,loki,elasticsearch"
```

### Web Development Stack
```bash
# Web dev tools
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "nodejs,php,mysql,nginx,caddy"
```

### DevOps Infrastructure Tools
```bash
# Infrastructure automation
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "terraform,pulumi,consul,docker,kubernetes"
```

## Install by Category

### Container Platform
```bash
ansible-playbook -i inventory/hosts.ini sites.yml --tags "container"
```

### All Databases
```bash
ansible-playbook -i inventory/hosts.ini sites.yml --tags "database"
```

### All IDEs
```bash
ansible-playbook -i inventory/hosts.ini sites.yml --tags "ide"
```

### VPN & Networking
```bash
ansible-playbook -i inventory/hosts.ini sites.yml --tags "vpn"
```

### AI Agents
```bash
ansible-playbook -i inventory/hosts.ini sites.yml --tags "agent"
```

## Install Individual Tools

### Single Role
```bash
# Install just Docker
ansible-playbook -i inventory/hosts.ini sites.yml --tags "docker"

# Install just Grafana
ansible-playbook -i inventory/hosts.ini sites.yml --tags "grafana"

# Install just Ollama
ansible-playbook -i inventory/hosts.ini sites.yml --tags "ollama"
```

### Multiple Specific Tools
```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "docker,postgresql,grafana,nginx"
```

## Target Specific Hosts

### Single Host
```bash
ansible-playbook -i inventory/hosts.ini sites.yml --limit cbwhpz
```

### Host Group
```bash
ansible-playbook -i inventory/hosts.ini sites.yml --limit devops
```

## Check Mode (Dry Run)

Preview changes without applying:
```bash
ansible-playbook -i inventory/hosts.ini sites.yml --check
```

With diff:
```bash
ansible-playbook -i inventory/hosts.ini sites.yml --check --diff
```

## Verbose Output

```bash
# Level 1: Basic
ansible-playbook -i inventory/hosts.ini sites.yml -v

# Level 2: More details
ansible-playbook -i inventory/hosts.ini sites.yml -vv

# Level 3: Debug
ansible-playbook -i inventory/hosts.ini sites.yml -vvv
```

## Skip Roles

Skip specific roles:
```bash
ansible-playbook -i inventory/hosts.ini sites.yml --skip-tags "docker,kubernetes"
```

## List Available Tags

```bash
ansible-playbook -i inventory/hosts.ini sites.yml --list-tags
```

## List Available Hosts

```bash
ansible-playbook -i inventory/hosts.ini sites.yml --list-hosts
```

## Common Troubleshooting

### Connection Issues
```bash
# Test connection
ansible -i inventory/hosts.ini devops -m ping

# Check inventory
ansible-inventory -i inventory/hosts.ini --list
```

### Role-Specific Issues
```bash
# Run with verbose output and only one role
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "problematic-role" -vvv
```

### Skip Failing Tasks
```bash
# Continue on errors
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "database" --ignore-errors
```

## Configuration

### Set Variables on Command Line
```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "grafana" \
  -e "grafana_admin_password=SecurePass123"
```

### Use Vault for Secrets
```bash
# Create vault
ansible-vault create group_vars/vault.yml

# Run with vault
ansible-playbook -i inventory/hosts.ini sites.yml --ask-vault-pass
```

## Performance

### Parallel Execution
```bash
# Run on 10 hosts in parallel
ansible-playbook -i inventory/hosts.ini sites.yml -f 10
```

### Start at Specific Role
```bash
# Resume from a specific role
ansible-playbook -i inventory/hosts.ini sites.yml \
  --start-at-task="Install PostgreSQL"
```

## Tag Reference

| Tag | Description | Example Roles |
|-----|-------------|---------------|
| `python` | Python tools | python, uv, pydantic |
| `lang` | Programming languages | python, nodejs, php |
| `container` | Container runtimes | docker, podman |
| `database` | Database systems | postgresql, mysql, clickhouse |
| `webserver` | Web servers | nginx, apache2, caddy |
| `proxy` | Reverse proxies | traefik, caddy |
| `ai` | AI/ML tools | ollama, localai, openwebui |
| `monitoring` | Monitoring tools | prometheus, grafana |
| `logging` | Logging systems | loki, elasticsearch, graylog |
| `iac` | Infrastructure as Code | terraform, pulumi |
| `auth` | Authentication | keycloak, bitwarden |
| `ide` | Development environments | vscode, cursor, zed |
| `vpn` | VPN and networking | tailscale, wireguard |
| `cloud` | Cloud storage | nextcloud, owncloud |
| `git` | Git services | gitlab, gitea |
| `agent` | AI agent frameworks | agent-zero, anythingllm |
| `search` | Search engines | searxng, exa |
| `scraping` | Web scraping | firecrawl, crawl4ai |
| `streaming` | Message streaming | kafka, n8n |
| `remote` | Remote access | guacamole, openssh, cockpit |

## Examples

### Complete Dev Workstation
```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "lang,ide,docker,git,database" \
  --limit cbwhpz
```

### Production Monitoring Server
```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "monitoring,logging,database" \
  --limit monitoring-server
```

### AI Research Environment
```bash
ansible-playbook -i inventory/hosts.ini sites.yml \
  --tags "python,ai,agent,docker" \
  -e "ollama_models=['llama2','codellama','mistral','phi']"
```
