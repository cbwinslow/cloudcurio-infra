# Quick Start Guide - CloudCurio Infrastructure

This guide will help you quickly set up your infrastructure using the provided tools and automation.

## Prerequisites

- Ubuntu/Debian-based Linux system
- SSH access to target hosts
- Ansible 2.9+ (for automated deployment)
- Sudo/root access

## Quick Setup Options

### Option 1: Automated Ansible Deployment (Recommended)

This is the recommended approach for production environments.

1. **Clone the repository:**
   ```bash
   git clone https://github.com/cbwinslow/cloudcurio-infra.git
   cd cloudcurio-infra
   ```

2. **Configure your inventory:**
   
   The inventory is already configured with ZeroTier IP addresses:
   ```bash
   cat inventory/hosts.ini
   ```

3. **Test connectivity:**
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml
   ```

4. **Deploy full infrastructure:**
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/master_infrastructure_setup.yml
   ```

### Option 2: Manual Installation with Scripts

For quick manual installation on a single host:

1. **Run the master installer:**
   ```bash
   cd cloudcurio-infra
   bash scripts/master_installer.sh
   ```

2. **Or install specific components:**
   ```bash
   # Install Docker
   bash scripts/installers/container/install_docker.sh
   
   # Install monitoring stack
   bash scripts/installers/monitoring/install_monitoring_stack.sh
   
   # Install AI/ML stack
   bash scripts/installers/ai-ml/install_ai_stack.sh
   
   # Install ZeroTier
   bash scripts/installers/networking/install_zerotier.sh
   ```

## ZeroTier Network Setup

All hosts are configured to use ZeroTier for secure mesh networking:

```
cbwdellr720  → 172.28.82.205  (Dell R720 Server)
cbwhpz       → 172.28.27.157  (HP Workstation)
cbwamd       → 172.28.176.115 (AMD System)
cbwlapkali   → 172.28.196.74  (Kali Linux Laptop)
cbwmac       → 172.28.169.48  (Mac System)
```

### Join ZeroTier Network

After installing ZeroTier:

```bash
# Install ZeroTier
sudo zerotier-cli join <your-network-id>

# Authorize the node in ZeroTier Central
# Get your node ID
sudo zerotier-cli info

# Check status
sudo zerotier-cli listnetworks
```

## Common Deployment Scenarios

### Scenario 1: Monitoring Infrastructure

Deploy Prometheus, Grafana, and Loki on all nodes:

```bash
ansible-playbook -i inventory/hosts.ini -t monitoring site.yml
```

Or on specific host:
```bash
ansible-playbook -i inventory/hosts.ini -l cbwdellr720 -t monitoring site.yml
```

### Scenario 2: AI/ML Development Environment

Deploy AI/ML stack on a specific host:

```bash
ansible-playbook -i inventory/hosts.ini -l cbwamd playbooks/master_infrastructure_setup.yml \
  --tags "ai-ml,databases"
```

### Scenario 3: Security Monitoring

Deploy security tools across all nodes:

```bash
ansible-playbook -i inventory/hosts.ini playbooks/master_infrastructure_setup.yml \
  --tags "security,monitoring"
```

## Post-Installation Configuration

### 1. Access Web Interfaces

After installation, services are accessible at:

- **Grafana:** http://<host>:3000 (admin/admin)
- **Prometheus:** http://<host>:9090
- **AnythingLLM:** http://<host>:3001
- **LocalAI:** http://<host>:8080
- **n8n:** http://<host>:5678
- **Flowise:** http://<host>:3000
- **Qdrant:** http://<host>:6333

### 2. Configure Monitoring

1. **Add Prometheus targets** in `/etc/prometheus/prometheus.yml`
2. **Configure Grafana dashboards** via the web UI
3. **Set up Loki data source** in Grafana

### 3. Set Up Scheduled Tasks

Install cron jobs for maintenance:

```bash
# Copy cron templates
sudo cp templates/cron/system-maintenance.cron /etc/cron.d/system-maintenance
sudo cp templates/cron/monitoring.cron /etc/cron.d/monitoring
sudo cp templates/cron/backup.cron /etc/cron.d/backup

# Set permissions
sudo chmod 644 /etc/cron.d/*
```

### 4. Configure Systemd Services

Use provided systemd templates:

```bash
# Copy systemd service files
sudo cp templates/systemd/*.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable services
sudo systemctl enable prometheus loki
sudo systemctl start prometheus loki
```

## Verification

### Check Service Status

```bash
# Check all services
systemctl status prometheus grafana-server loki docker

# Check Docker containers
docker ps

# Check logs
sudo journalctl -u prometheus -n 50
```

### Network Connectivity

```bash
# Ping all ZeroTier nodes
ansible zerotier_nodes -i inventory/hosts.ini -m ping

# Check ZeroTier status
sudo zerotier-cli listpeers
```

### Monitoring Health

```bash
# Check Prometheus targets
curl http://localhost:9090/api/v1/targets

# Check Grafana health
curl http://localhost:3000/api/health

# Check Loki
curl http://localhost:3100/ready
```

## Troubleshooting

### Common Issues

1. **Service won't start:**
   ```bash
   sudo journalctl -u <service-name> -n 100
   sudo systemctl status <service-name>
   ```

2. **ZeroTier connectivity issues:**
   ```bash
   sudo zerotier-cli info
   sudo zerotier-cli listnetworks
   sudo systemctl restart zerotier-one
   ```

3. **Docker container issues:**
   ```bash
   docker logs <container-name>
   docker inspect <container-name>
   ```

4. **Ansible playbook failures:**
   ```bash
   # Run with verbose output
   ansible-playbook -i inventory/hosts.ini playbooks/master_infrastructure_setup.yml -vvv
   
   # Check connectivity first
   ansible all -i inventory/hosts.ini -m ping
   ```

## Security Considerations

1. **Change default passwords** for all services
2. **Configure firewall rules:**
   ```bash
   sudo ufw allow from 172.28.0.0/16
   sudo ufw enable
   ```
3. **Enable SSL/TLS** for web services
4. **Set up Wazuh** for security monitoring
5. **Review and customize** security configurations

## Next Steps

1. Review the [Infrastructure Guide](INFRASTRUCTURE_GUIDE.md) for detailed documentation
2. Customize variables in `group_vars/all.yml`
3. Create custom playbooks for your specific needs
4. Set up automated backups
5. Configure alerting in Prometheus/Grafana
6. Implement proper secrets management

## Additional Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Infrastructure Guide](INFRASTRUCTURE_GUIDE.md)
- [DevOps Tools Reference](DEVOPS_TOOLS_REFERENCE.md)
- [Contributing Guidelines](CONTRIBUTING.md)

## Support

- GitHub Issues: [Create an issue](https://github.com/cbwinslow/cloudcurio-infra/issues)
- Documentation: Check INFRASTRUCTURE_GUIDE.md for detailed info

---

**Happy Infrastructure Automation!** 🚀
