# CloudCurio Infrastructure Stack

Complete infrastructure deployment using the CloudCurio Pulumi library.

## Overview

This Pulumi stack manages:
- ZeroTier network and node configuration
- Monitoring infrastructure (Prometheus, Grafana, Loki)
- Database infrastructure (PostgreSQL, Redis)
- Web server infrastructure (Caddy)

## Prerequisites

- Python 3.8+
- Pulumi CLI installed
- ZeroTier network ID (optional)

## Setup

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Initialize Pulumi stack:**
   ```bash
   pulumi login
   pulumi stack init cloudcurio-prod
   ```

3. **Configure the stack:**
   ```bash
   pulumi config set zerotier_network_id YOUR_NETWORK_ID
   pulumi config set environment production
   ```

4. **Deploy the stack:**
   ```bash
   pulumi up
   ```

## Configuration

### Required Configuration

None - all configuration has defaults

### Optional Configuration

- `zerotier_network_id`: Your ZeroTier network ID
- `environment`: Environment name (default: production)

## Outputs

The stack exports:
- `zerotier_network_id`: ZeroTier network ID
- `zerotier_subnet`: Network subnet (172.28.0.0/16)
- `node_count`: Number of nodes in the network
- `nodes`: Dictionary of hostname to IP mappings
- `prometheus_port`: Prometheus port (9090)
- `grafana_port`: Grafana port (3000)
- `loki_port`: Loki port (3100)

## Usage

### View stack outputs
```bash
pulumi stack output
```

### View specific output
```bash
pulumi stack output nodes
```

### Update the stack
```bash
pulumi up
```

### Destroy the stack
```bash
pulumi destroy
```

## CloudCurio Library Components

This stack uses the following custom components from the CloudCurio library:

- **ZeroTierNetwork**: Manages ZeroTier network and nodes
- **MonitoringStack**: Deploys monitoring infrastructure
- **DatabaseStack**: Manages database services
- **WebServerStack**: Configures web servers

## Adding New Nodes

To add a new node to the ZeroTier network, edit `__main__.py` and add to `zerotier_nodes`:

```python
ZeroTierNodeArgs(
    hostname="newnode",
    ip_address="172.28.x.x",
    description="New Node",
    tags={"type": "server", "role": "application"}
)
```

Then run `pulumi up` to apply changes.
