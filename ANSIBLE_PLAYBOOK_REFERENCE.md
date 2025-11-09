# Ansible Playbook Reference

Complete reference for all Ansible playbooks in the CloudCurio infrastructure.

## Available Playbooks

### 1. setup_servers.yml

**Purpose**: Complete server setup and configuration

**Hosts**: servers

**What it does**:
- Tests connectivity
- Installs base packages (htop, vim, curl, git, etc.)
- Configures system limits (open files, processes)
- Sets up SSH with security hardening
- Installs and configures UFW firewall
- Installs and configures fail2ban
- Deploys Docker and Docker Compose
- Sets up monitoring stack (Prometheus, Grafana, Loki)
- Configures networking (ZeroTier, AutoSSH, SSH bastion)
- Installs systemd service templates
- Configures automated backups

**Usage**:
```bash
# Full setup
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml

# Specific tags
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml --tags base
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml --tags security
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml --tags monitoring
```

**Configuration**:
Edit `group_vars/servers.yml` to customize:
- `monitoring_enabled`: Enable/disable monitoring
- `ufw_enabled`: Enable/disable firewall
- `backup_enabled`: Enable/disable backups
- `backup_retention_days`: Backup retention period

### 2. setup_desktops.yml

**Purpose**: Complete desktop/workstation setup

**Hosts**: desktops

**What it does**:
- Tests connectivity
- Installs desktop packages (Firefox, VS Code, etc.)
- Installs development tools (Python, Node.js, Go, Java)
- Configures user environment
- Adds user to Docker and sudo groups
- Creates development directories (workspace, projects)
- Installs VS Code
- Configures Node.js and npm
- Sets up Docker for development
- Configures SSH and Git
- Installs AI/ML development tools
- Installs Flatpak and desktop applications
- Sets up ZeroTier networking
- Configures UFW firewall (more permissive than servers)
- Configures desktop backups

**Usage**:
```bash
# Full setup
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_desktops.yml

# Specific tags
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_desktops.yml --tags development
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_desktops.yml --tags user
```

**Configuration**:
Edit `group_vars/desktops.yml` to customize:
- `dev_tools_enabled`: Enable/disable development tools
- `install_vscode`: Install VS Code
- `docker_desktop_mode`: Enable Docker for development
- `backup_retention_days`: Backup retention period

### 3. setup_ssh_keys.yml

**Purpose**: Automated SSH key management and deployment

**Hosts**: all

**What it does**:
- Generates SSH key pair on local machine (ED25519)
- Deploys local public key to all hosts
- Generates SSH key pairs on all remote hosts
- Cross-deploys keys between hosts for passwordless SSH
- Configures SSH client with host entries
- Hardens SSH server configuration:
  - Disables password authentication
  - Disables root login
  - Enables public key authentication
  - Sets connection timeouts
- Tests SSH connectivity between all hosts

**Usage**:
```bash
# Full SSH key setup
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_ssh_keys.yml
```

**Features**:
- ED25519 keys (modern, secure)
- Automatic cross-host authentication
- SSH config with jump hosts
- Security hardening
- Automatic testing

### 4. setup_containers.yml

**Purpose**: Deploy and manage Docker container stacks

**Hosts**: all (varies by stack)

**What it does**:
- Installs Docker and Docker Compose
- Creates container directory structure
- Creates data directories for persistent volumes
- Deploys monitoring stack (Prometheus, Grafana, Loki, Node Exporter, Promtail)
- Deploys AI/ML stack (LocalAI, AnythingLLM, Qdrant, Weaviate, Langfuse)
- Deploys database stack (PostgreSQL, MySQL, Redis, MongoDB, Adminer)
- Deploys web stack (Caddy, Nginx, Portainer)
- Configures systemd services for container stacks
- Performs health checks on containers

**Usage**:
```bash
# Full container setup
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_containers.yml

# Monitoring stack only (on servers)
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_containers.yml --limit servers
```

**Configuration**:
Edit group_vars to enable/disable stacks:
- `monitoring_enabled`: Enable monitoring stack
- `ai_ml_enabled`: Enable AI/ML stack
- `database_stack_enabled`: Enable database stack
- `web_stack_enabled`: Enable web stack

**Container Stacks**:

1. **Monitoring Stack** (`/opt/containers/monitoring/`)
   - Prometheus (9090)
   - Grafana (3000)
   - Loki (3100)
   - Node Exporter (9100)
   - Promtail

2. **AI/ML Stack** (`/opt/containers/ai-ml/`)
   - LocalAI (8080)
   - AnythingLLM (3001)
   - Qdrant (6333, 6334)
   - Weaviate (8081)
   - Langfuse (3002)
   - PostgreSQL (internal)

3. **Database Stack** (`/opt/containers/databases/`)
   - PostgreSQL (5432)
   - MySQL (3306)
   - Redis (6379)
   - MongoDB (27017)
   - Adminer (8082)

4. **Web Stack** (`/opt/containers/web/`)
   - Caddy (80, 443)
   - Nginx (8083)
   - Portainer (9000, 9443)

## Inventory Structure

### Environments

```
inventory/
├── production/
│   └── hosts.ini          # Production hosts
├── staging/
│   └── hosts.ini          # Staging hosts
└── development/
    └── hosts.ini          # Development hosts
```

### Host Groups

- **servers**: Production servers
- **desktops**: Desktop/workstation hosts
- **workstations**: Physical workstations
- **zerotier_nodes**: Hosts on ZeroTier VPN
- **production/staging/development**: Environment groups

## Group Variables

### group_vars/all.yml

Common settings for all hosts:
- `hostname_map`: Local hostname to IP mapping
- `zerotier_hostname_map`: ZeroTier IP mappings

### group_vars/servers.yml

Server-specific settings:
- Package lists
- Monitoring configuration
- Security settings (UFW, fail2ban, SSH)
- Container runtime settings
- Backup configuration
- System resource limits
- Time synchronization

### group_vars/desktops.yml

Desktop-specific settings:
- Desktop and development packages
- Development tools configuration
- GUI settings
- User configuration
- IDE preferences
- Container development settings
- Backup configuration

### group_vars/zerotier_nodes.yml

ZeroTier network settings:
- Network configuration
- DNS settings
- Firewall rules for ZeroTier subnet
- SSH configuration
- Monitoring targets

## Common Tasks

### Setup New Server

```bash
# 1. Add to inventory
echo "newserver ansible_host=192.168.1.100 ansible_user=admin" >> inventory/production/hosts.ini

# 2. Test connectivity
ansible newserver -i inventory/production/hosts.ini -m ping

# 3. Run setup
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml --limit newserver

# 4. Setup SSH keys
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_ssh_keys.yml --limit newserver

# 5. Deploy containers
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_containers.yml --limit newserver
```

### Setup New Desktop

```bash
# 1. Add to inventory
echo "newdesktop ansible_host=192.168.1.101 ansible_user=user" >> inventory/production/hosts.ini

# 2. Test connectivity
ansible newdesktop -i inventory/production/hosts.ini -m ping

# 3. Run setup
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_desktops.yml --limit newdesktop

# 4. Setup SSH keys
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_ssh_keys.yml
```

### Update All Hosts

```bash
# Update packages
ansible all -i inventory/production/hosts.ini -b -m apt -a "update_cache=yes upgrade=dist"

# Restart services
ansible all -i inventory/production/hosts.ini -b -m systemd -a "name=docker state=restarted"
```

### Check Container Status

```bash
# List running containers
ansible all -i inventory/production/hosts.ini -b -m command -a "docker ps"

# Check specific stack
ansible servers -i inventory/production/hosts.ini -b -a "docker compose -f /opt/containers/monitoring/docker-compose.yml ps"
```

## Troubleshooting

### Connection Issues

```bash
# Verbose output
ansible-playbook -vvv -i inventory/production/hosts.ini playbooks/setup_servers.yml

# Test specific host
ansible myhost -i inventory/production/hosts.ini -m ping

# Check SSH
ssh -vvv user@host
```

### Playbook Failures

```bash
# Check syntax
ansible-playbook --syntax-check playbooks/setup_servers.yml

# Dry run
ansible-playbook --check -i inventory/production/hosts.ini playbooks/setup_servers.yml

# Run specific tasks
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml --start-at-task="Install base packages"
```

### Container Issues

```bash
# Check Docker
ansible all -i inventory/production/hosts.ini -b -m systemd -a "name=docker state=started"

# View logs
ansible servers -i inventory/production/hosts.ini -b -a "docker compose -f /opt/containers/monitoring/docker-compose.yml logs --tail=50"

# Restart stack
ansible servers -i inventory/production/hosts.ini -b -a "docker compose -f /opt/containers/monitoring/docker-compose.yml restart"
```

## Best Practices

1. **Test in Staging First**: Always test playbooks in staging before production
2. **Use Limits**: Use `--limit` to target specific hosts
3. **Check Mode**: Use `--check` for dry runs
4. **Verbose Output**: Use `-v` flags for debugging
5. **Tag Usage**: Use tags to run specific parts of playbooks
6. **Backup First**: Always backup before major changes
7. **Document Changes**: Update inventory and group_vars documentation
8. **Version Control**: Commit all changes to git
9. **SSH Key Security**: Keep private keys secure, rotate regularly
10. **Monitor Logs**: Check logs after deployments

## Integration with Pulumi

Ansible and Pulumi work together:

1. **Pulumi**: Provisions cloud infrastructure (DNS, WAF, tunnels)
2. **Ansible**: Configures servers and installs software
3. **Both**: Use same ZeroTier IP mappings

### Workflow

```bash
# 1. Deploy cloud infrastructure with Pulumi
cd pulumi/networking
pulumi up

# 2. Configure servers with Ansible
cd ../..
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_servers.yml

# 3. Deploy containers
ansible-playbook -i inventory/production/hosts.ini playbooks/setup_containers.yml
```

## Support

- **Documentation**: See SETUP_GUIDE.md, PULUMI_GUIDE.md
- **Issues**: [GitHub Issues](https://github.com/cbwinslow/cloudcurio-infra/issues)
- **Discussions**: [GitHub Discussions](https://github.com/cbwinslow/cloudcurio-infra/discussions)
