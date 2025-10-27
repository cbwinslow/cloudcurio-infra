# Infrastructure Roles and Scripts

This directory contains organized Ansible roles and installer scripts for comprehensive infrastructure automation.

## Directory Structure

```
roles/
├── networking/          # Network-related tools and services
│   ├── zerotier/       # ZeroTier VPN mesh network
│   ├── autossh/        # Automatic SSH tunneling
│   ├── ssh-bastion/    # SSH bastion host configuration
│   └── cloudflare-tunnels/  # Cloudflare tunnels for secure access
│
├── monitoring/         # Monitoring and observability stack
│   ├── prometheus/     # Metrics collection and alerting
│   ├── grafana/        # Visualization and dashboards
│   ├── loki/          # Log aggregation
│   ├── suricata/      # Network IDS/IPS
│   ├── wazuh/         # Security monitoring and SIEM
│   ├── syslog/        # Centralized logging
│   └── opensearch/    # Search and analytics engine
│
├── security/           # Security tools and SIEM
│   ├── wazuh/         # Host-based intrusion detection
│   ├── suricata/      # Network intrusion detection
│   └── secrets-management/  # Secrets management solutions
│
├── container/          # Container runtime and orchestration
│   ├── docker/        # Docker engine
│   └── docker-compose/  # Docker Compose
│
├── automation/         # Automation and workflow tools
│   ├── salt-stack/    # Configuration management
│   ├── n8n/          # Workflow automation
│   └── flowise/      # Low-code AI workflows
│
├── ai-ml/             # AI and Machine Learning tools
│   ├── anythingllm/   # Document Q&A with LLMs
│   ├── localai/       # Local AI inference
│   ├── langfuse/      # LLM observability
│   ├── agent-zero/    # AI agent framework
│   └── mcp-servers/   # Model Context Protocol servers
│
├── databases/         # Vector and traditional databases
│   ├── qdrant/        # Vector database
│   ├── weaviate/      # AI-native vector database
│   └── opensearch/    # Distributed search engine
│
├── infrastructure/    # Core infrastructure tools
│   ├── teleport/      # Access management
│   ├── systemd-services/  # Systemd service templates
│   ├── cron-jobs/     # Scheduled task templates
│   ├── chezmoi/       # Dotfile management
│   └── websockets/    # WebSocket server configurations
│
├── web/               # Web servers and proxies
│   ├── apache/        # Apache HTTP Server
│   ├── nginx/         # Nginx web server
│   ├── caddy/         # Caddy web server
│   └── websockets/    # WebSocket implementations
│
└── development/       # Development tools
    └── code-server/   # VS Code in the browser
```

## Installer Scripts

Standalone installation scripts are available in `scripts/installers/`:

- **networking/**: ZeroTier, AutoSSH, Cloudflare Tunnels
- **monitoring/**: Complete monitoring stack (Prometheus, Grafana, Loki)
- **security/**: Wazuh, Suricata, security hardening
- **container/**: Docker and Docker Compose
- **automation/**: SaltStack, Ansible, workflow tools
- **ai-ml/**: AI/ML stack with AnythingLLM, LocalAI, Langfuse, Qdrant
- **databases/**: Vector databases and search engines
- **infrastructure/**: System tools and utilities

### Quick Start with Installer Scripts

```bash
# Install Docker and Docker Compose
bash scripts/installers/container/install_docker.sh

# Install monitoring stack
bash scripts/installers/monitoring/install_monitoring_stack.sh

# Install AI/ML stack
bash scripts/installers/ai-ml/install_ai_stack.sh

# Install ZeroTier
bash scripts/installers/networking/install_zerotier.sh

# Install SaltStack
bash scripts/installers/automation/install_saltstack.sh
```

## ZeroTier Network Configuration

The infrastructure uses ZeroTier for secure mesh networking:

| Hostname      | ZeroTier IP     | Description           |
|--------------|-----------------|------------------------|
| cbwdellr720  | 172.28.82.205   | Dell R720 server       |
| cbwhpz       | 172.28.27.157   | HP workstation         |
| cbwamd       | 172.28.176.115  | AMD system             |
| cbwlapkali   | 172.28.196.74   | Kali Linux laptop      |
| cbwmac       | 172.28.169.48   | Mac system             |

## Usage

### Running Playbooks

1. **Test network connectivity:**
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml
   ```

2. **Complete infrastructure setup:**
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/master_infrastructure_setup.yml
   ```

3. **Install specific role:**
   ```bash
   ansible-playbook -i inventory/hosts.ini -e "role=monitoring/prometheus" playbooks/install_role.yml
   ```

### Using Roles in Custom Playbooks

```yaml
---
- name: Install monitoring on specific host
  hosts: cbwdellr720
  become: yes
  roles:
    - monitoring/prometheus
    - monitoring/grafana
    - monitoring/loki
```

## Systemd Service Templates

Pre-configured systemd service templates are available in `templates/systemd/`:

- `prometheus.service` - Prometheus monitoring
- `loki.service` - Loki log aggregation
- `autossh@.service` - AutoSSH tunnel template
- `docker-compose@.service` - Docker Compose application template

### Using Systemd Templates

```bash
# Copy template to systemd directory
sudo cp templates/systemd/prometheus.service /etc/systemd/system/

# Reload systemd and start service
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus
```

## Cron Job Templates

Common cron job configurations are in `templates/cron/`:

- `system-maintenance.cron` - System updates, cleanup, backups
- `monitoring.cron` - Health checks and metrics exports
- `backup.cron` - Automated backup schedules

### Installing Cron Jobs

```bash
# Add to root's crontab
sudo crontab -e
# Then paste contents from desired .cron file

# Or install directly
sudo crontab -l > /tmp/current_cron
cat templates/cron/system-maintenance.cron >> /tmp/current_cron
sudo crontab /tmp/current_cron
```

## Variables

Configure roles using variables in `group_vars/all.yml`:

```yaml
# ZeroTier configuration
zerotier_network_id: "your-network-id"

# Monitoring
prometheus_version: "2.45.0"
loki_version: "2.9.0"

# Security
wazuh_manager_ip: "192.168.1.100"
salt_master_ip: "192.168.1.100"

# Infrastructure
teleport_version: "13.0.0"
teleport_auth_server: "teleport.example.com:443"

# AI/ML
enable_gpu: false
```

## Security Considerations

- All services should be configured with proper authentication
- Use strong passwords and rotate them regularly
- Enable SSL/TLS for all web services
- Configure firewall rules using UFW or iptables
- Keep all systems and packages updated
- Monitor security logs regularly with Wazuh and Suricata

## Maintenance

### Regular Tasks

1. **Update systems weekly:**
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/update_systems.yml
   ```

2. **Check service health:**
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/health_check.yml
   ```

3. **Backup configurations:**
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/backup_configs.yml
   ```

## Troubleshooting

### Network Connectivity Issues

```bash
# Test ZeroTier connectivity
ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml

# Check ZeroTier status on individual nodes
sudo zerotier-cli listnetworks
sudo zerotier-cli peers
```

### Service Issues

```bash
# Check systemd service status
sudo systemctl status prometheus
sudo journalctl -u prometheus -n 50

# Check Docker containers
docker ps -a
docker logs <container_name>
```

### Role Installation Issues

```bash
# Run with verbose output
ansible-playbook -i inventory/hosts.ini playbooks/master_infrastructure_setup.yml -vvv

# Run specific role with check mode (dry run)
ansible-playbook -i inventory/hosts.ini --check --diff playbooks/install_role.yml
```

## Contributing

When adding new roles:

1. Create role directory under appropriate category
2. Include tasks/main.yml at minimum
3. Add templates, handlers, defaults as needed
4. Create corresponding installer script
5. Update this README
6. Test thoroughly before committing

## Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [ZeroTier Documentation](https://docs.zerotier.com/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Wazuh Documentation](https://documentation.wazuh.com/)

## License

See repository LICENSE file for details.
