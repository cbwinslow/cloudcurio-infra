# CloudCurio Pulumi Guide

Complete guide for using Pulumi to manage CloudCurio infrastructure.

## Overview

CloudCurio uses a custom Pulumi library and multiple stacks to manage infrastructure:

- **cloudcurio-lib**: Custom Python library with reusable components
- **infrastructure**: Complete infrastructure deployment
- **networking**: DNS, tunnels, and network configuration
- **security**: WAF, Access policies, and security rules
- **cloudflare**: Cloudflare-specific resources
- **vercel**: Vercel deployment configuration

## CloudCurio Library

The `cloudcurio-lib` provides reusable infrastructure components:

### Components

1. **ZeroTier Components**
   - `ZeroTierNode`: Individual ZeroTier node configuration
   - `ZeroTierNetwork`: Complete network with multiple nodes

2. **Monitoring Components**
   - `MonitoringStack`: Prometheus, Grafana, Loki deployment

3. **Database Components**
   - `DatabaseStack`: PostgreSQL, MySQL, Redis, MongoDB

4. **Web Server Components**
   - `WebServerStack`: Caddy, Nginx, Apache configuration

### Using the Library

```python
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from cloudcurio_lib.zerotier import ZeroTierNetwork, ZeroTierNodeArgs
from cloudcurio_lib.monitoring import MonitoringStack, MonitoringStackArgs

# Create ZeroTier network
network = ZeroTierNetwork("my-network", args={...})

# Deploy monitoring
monitoring = MonitoringStack("my-monitoring", MonitoringStackArgs(...))
```

## Stack Deployments

### Infrastructure Stack

Complete infrastructure deployment with ZeroTier, monitoring, databases, and web servers.

```bash
cd pulumi/infrastructure
pip install -r requirements.txt
pulumi login
pulumi stack init cloudcurio-prod
pulumi config set zerotier_network_id YOUR_NETWORK_ID
pulumi up
```

**Outputs:**
- `zerotier_network_id`: Network ID
- `nodes`: Dictionary of nodes and IPs
- `prometheus_port`, `grafana_port`, `loki_port`: Service ports

### Networking Stack

DNS, Cloudflare Tunnels, and network configuration.

```bash
cd pulumi/networking
pip install -r requirements.txt
pulumi login
pulumi stack init cloudcurio-networking
pulumi config set cloudflare:apiToken YOUR_TOKEN --secret
pulumi config set cloudflare_account_id YOUR_ACCOUNT_ID
pulumi config set tunnel_secret YOUR_SECRET --secret
pulumi up
```

**Features:**
- Automatic DNS records for all ZeroTier nodes
- Cloudflare Tunnel for secure access to internal services
- DNS records for Grafana, Prometheus, Loki, AnythingLLM

### Security Stack

WAF rules, Cloudflare Access, and security policies.

```bash
cd pulumi/security
pip install -r requirements.txt
pulumi login
pulumi stack init cloudcurio-security
pulumi config set cloudflare:apiToken YOUR_TOKEN --secret
pulumi config set cloudflare_account_id YOUR_ACCOUNT_ID
pulumi up
```

**Features:**
- WAF rules (geo-blocking, threat detection, bot management)
- Rate limiting for API endpoints
- Cloudflare Access for internal services
- Security headers via Page Rules

### Cloudflare Stack

Original comprehensive Cloudflare configuration.

```bash
cd pulumi/cloudflare
pip install -r requirements.txt
pulumi login
pulumi stack init cloudcurio-cloudflare
pulumi config set cloudflare:apiToken YOUR_TOKEN --secret
pulumi config set cloudflare_account_id YOUR_ACCOUNT_ID
pulumi config set tunnel_secret YOUR_SECRET --secret
pulumi up
```

## Configuration Management

### Environment Variables

Set sensitive configuration as secrets:

```bash
pulumi config set --secret apiToken YOUR_TOKEN
pulumi config set --secret tunnel_secret YOUR_SECRET
pulumi config set --secret grafana_admin_password YOUR_PASSWORD
```

### Multiple Environments

Create separate stacks for different environments:

```bash
# Production
pulumi stack init cloudcurio-prod
pulumi config set environment production

# Staging
pulumi stack init cloudcurio-staging
pulumi config set environment staging

# Development
pulumi stack init cloudcurio-dev
pulumi config set environment development
```

### Switching Between Stacks

```bash
pulumi stack select cloudcurio-prod
pulumi up

pulumi stack select cloudcurio-staging
pulumi up
```

## Common Operations

### View Stack Outputs

```bash
pulumi stack output
pulumi stack output nodes
pulumi stack output zerotier_network_id
```

### Update Infrastructure

```bash
pulumi up
```

### Preview Changes

```bash
pulumi preview
```

### Destroy Resources

```bash
pulumi destroy
```

### Export Stack State

```bash
pulumi stack export > stack-backup.json
```

### Import Stack State

```bash
pulumi stack import < stack-backup.json
```

## Integration with Ansible

Pulumi and Ansible work together:

1. **Pulumi** provisions cloud infrastructure (DNS, tunnels, WAF)
2. **Ansible** configures servers and installs software
3. **Both** use the same ZeroTier IP mappings

### Sharing Configuration

Use Pulumi outputs in Ansible:

```bash
# Get Pulumi outputs
pulumi stack output nodes -j > ansible/zerotier_nodes.json

# Use in Ansible
ansible-playbook -e "@zerotier_nodes.json" playbook.yml
```

## Adding New Nodes

### 1. Update CloudCurio Library Usage

Edit `pulumi/infrastructure/__main__.py`:

```python
zerotier_nodes = [
    # ... existing nodes ...
    ZeroTierNodeArgs(
        hostname="newnode",
        ip_address="172.28.x.x",
        description="New Node",
        tags={"type": "server", "role": "application"}
    ),
]
```

### 2. Update Networking Stack

The networking stack will automatically create DNS records for new nodes.

### 3. Deploy Changes

```bash
cd pulumi/infrastructure
pulumi up

cd ../networking
pulumi up
```

### 4. Update Ansible Inventory

Add the node to `inventory/hosts.ini`:

```ini
[servers]
newnode ansible_host=172.28.x.x ansible_user=cbwinslow
```

## Best Practices

### 1. Secret Management

Always use `--secret` flag for sensitive values:

```bash
pulumi config set --secret database_password YOUR_PASSWORD
```

### 2. State Management

Use Pulumi Cloud or self-hosted backend:

```bash
# Pulumi Cloud (default)
pulumi login

# Self-hosted (S3)
pulumi login s3://my-pulumi-state-bucket
```

### 3. Version Control

- Commit `Pulumi.yaml` and code
- Do NOT commit `Pulumi.<stack>.yaml` with secrets
- Use `.gitignore` for sensitive files

### 4. Testing

Test changes in staging before production:

```bash
pulumi stack select cloudcurio-staging
pulumi preview
pulumi up
# Verify changes
pulumi stack select cloudcurio-prod
pulumi up
```

### 5. Documentation

Document all infrastructure changes and configurations.

## Troubleshooting

### Stack Refresh

If stack is out of sync:

```bash
pulumi refresh
```

### Clear State

To clear corrupted state:

```bash
pulumi cancel
pulumi refresh
```

### View Detailed Logs

```bash
pulumi up --logtostderr -v=9
```

### Debug Python Code

Add print statements or use debugger:

```python
import pulumi
pulumi.log.info(f"Creating node: {hostname}")
```

## Resources

- [Pulumi Documentation](https://www.pulumi.com/docs/)
- [Pulumi Cloudflare Provider](https://www.pulumi.com/registry/packages/cloudflare/)
- [Python Pulumi Guide](https://www.pulumi.com/docs/intro/languages/python/)
- [CloudCurio Infrastructure Guide](INFRASTRUCTURE_GUIDE.md)
