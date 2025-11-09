# CloudCurio Pulumi Library

Custom Pulumi components for CloudCurio infrastructure management.

## Overview

The CloudCurio Pulumi Library provides high-level, reusable components for managing infrastructure:

- **ZeroTier Components**: Network and node management
- **Monitoring Components**: Prometheus, Grafana, Loki stacks
- **Database Components**: PostgreSQL, MySQL, Redis, MongoDB
- **Web Server Components**: Caddy, Nginx, Apache

## Installation

Add the library to your Pulumi Python path:

```python
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from cloudcurio_lib import ZeroTierNetwork, MonitoringStack
```

## Components

### ZeroTier Components

#### ZeroTierNode

Represents a single node in a ZeroTier network.

```python
from cloudcurio_lib.zerotier import ZeroTierNode, ZeroTierNodeArgs

node = ZeroTierNode(
    "my-node",
    ZeroTierNodeArgs(
        hostname="server01",
        ip_address="172.28.82.205",
        description="Production Server",
        authorized=True,
        tags={"role": "server", "env": "production"}
    )
)
```

**Arguments:**
- `hostname` (str, required): Hostname of the node
- `ip_address` (str, required): ZeroTier IP address
- `description` (str, optional): Node description
- `authorized` (bool, optional): Authorization status (default: True)
- `tags` (dict, optional): Additional tags

**Outputs:**
- `hostname`: Node hostname
- `ip_address`: Node IP address
- `description`: Node description

#### ZeroTierNetwork

Manages a complete ZeroTier network with multiple nodes.

```python
from cloudcurio_lib.zerotier import ZeroTierNetwork, ZeroTierNodeArgs

nodes = [
    ZeroTierNodeArgs(
        hostname="server01",
        ip_address="172.28.82.205",
        description="Server 1"
    ),
    ZeroTierNodeArgs(
        hostname="server02",
        ip_address="172.28.82.206",
        description="Server 2"
    ),
]

network = ZeroTierNetwork(
    "my-network",
    args={
        'network_id': 'YOUR_NETWORK_ID',
        'network_name': 'Production Network',
        'nodes': nodes,
        'subnet': '172.28.0.0/16',
    }
)
```

**Arguments:**
- `network_id` (str, required): ZeroTier network ID
- `network_name` (str, required): Network name
- `nodes` (list, required): List of ZeroTierNodeArgs
- `subnet` (str, optional): Network subnet (default: 172.28.0.0/16)

**Outputs:**
- `network_id`: Network ID
- `network_name`: Network name
- `subnet`: Network subnet
- `node_count`: Number of nodes

### Monitoring Components

#### MonitoringStack

Deploys monitoring infrastructure (Prometheus, Grafana, Loki).

```python
from cloudcurio_lib.monitoring import MonitoringStack, MonitoringStackArgs

monitoring = MonitoringStack(
    "my-monitoring",
    MonitoringStackArgs(
        prometheus_enabled=True,
        grafana_enabled=True,
        loki_enabled=True,
        retention_days=90,
        scrape_interval="15s",
        targets=["172.28.82.205", "172.28.82.206"]
    )
)
```

**Arguments:**
- `prometheus_enabled` (bool, optional): Enable Prometheus (default: True)
- `grafana_enabled` (bool, optional): Enable Grafana (default: True)
- `loki_enabled` (bool, optional): Enable Loki (default: True)
- `retention_days` (int, optional): Data retention in days (default: 90)
- `scrape_interval` (str, optional): Prometheus scrape interval (default: 15s)
- `targets` (list, optional): List of targets to monitor

**Outputs:**
- `prometheus_enabled`: Prometheus status
- `grafana_enabled`: Grafana status
- `loki_enabled`: Loki status
- `prometheus_port`: Prometheus port (9090)
- `grafana_port`: Grafana port (3000)
- `loki_port`: Loki port (3100)

#### PrometheusConfig

Helper class for generating Prometheus configuration.

```python
from cloudcurio_lib.monitoring import PrometheusConfig

config = PrometheusConfig.generate_config(
    scrape_interval="15s",
    targets=["172.28.82.205", "172.28.82.206"],
    retention_days=90
)
```

### Database Components

#### DatabaseStack

Manages database infrastructure.

```python
from cloudcurio_lib.database import DatabaseStack, DatabaseStackArgs

databases = DatabaseStack(
    "my-databases",
    DatabaseStackArgs(
        postgres_enabled=True,
        mysql_enabled=False,
        redis_enabled=True,
        mongodb_enabled=False,
        postgres_version="15",
        redis_version="7"
    )
)
```

**Arguments:**
- `postgres_enabled` (bool, optional): Enable PostgreSQL (default: True)
- `mysql_enabled` (bool, optional): Enable MySQL (default: False)
- `redis_enabled` (bool, optional): Enable Redis (default: True)
- `mongodb_enabled` (bool, optional): Enable MongoDB (default: False)
- `postgres_version` (str, optional): PostgreSQL version (default: "15")
- `mysql_version` (str, optional): MySQL version (default: "8.0")
- `redis_version` (str, optional): Redis version (default: "7")
- `mongodb_version` (str, optional): MongoDB version (default: "6")

**Outputs:**
- `databases`: Dictionary of enabled databases with ports and versions
- `postgres_enabled`: PostgreSQL status
- `mysql_enabled`: MySQL status
- `redis_enabled`: Redis status
- `mongodb_enabled`: MongoDB status

### Web Server Components

#### WebServerStack

Configures web server infrastructure.

```python
from cloudcurio_lib.web import WebServerStack, WebServerStackArgs

web = WebServerStack(
    "my-web",
    WebServerStackArgs(
        server_type="caddy",
        domains=["example.com", "*.example.com"],
        ssl_enabled=True,
        http_port=80,
        https_port=443
    )
)
```

**Arguments:**
- `server_type` (str, optional): Web server type (caddy, nginx, apache) (default: caddy)
- `domains` (list, optional): List of domains to serve
- `ssl_enabled` (bool, optional): Enable SSL/TLS (default: True)
- `http_port` (int, optional): HTTP port (default: 80)
- `https_port` (int, optional): HTTPS port (default: 443)

**Outputs:**
- `server_type`: Web server type
- `domains`: List of domains
- `http_port`: HTTP port
- `https_port`: HTTPS port
- `ssl_enabled`: SSL status

## Complete Example

```python
import pulumi
from pulumi import export
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from cloudcurio_lib.zerotier import ZeroTierNetwork, ZeroTierNodeArgs
from cloudcurio_lib.monitoring import MonitoringStack, MonitoringStackArgs
from cloudcurio_lib.database import DatabaseStack, DatabaseStackArgs
from cloudcurio_lib.web import WebServerStack, WebServerStackArgs

# Define nodes
nodes = [
    ZeroTierNodeArgs(
        hostname="server01",
        ip_address="172.28.82.205",
        description="Production Server",
        tags={"role": "server"}
    ),
    ZeroTierNodeArgs(
        hostname="desktop01",
        ip_address="172.28.82.206",
        description="Development Desktop",
        tags={"role": "desktop"}
    ),
]

# Create network
network = ZeroTierNetwork(
    "production-network",
    args={
        'network_id': 'YOUR_NETWORK_ID',
        'network_name': 'Production',
        'nodes': nodes,
        'subnet': '172.28.0.0/16',
    }
)

# Deploy monitoring
monitoring = MonitoringStack(
    "monitoring",
    MonitoringStackArgs(
        prometheus_enabled=True,
        grafana_enabled=True,
        loki_enabled=True,
        targets=[node.ip_address for node in nodes]
    )
)

# Deploy databases
databases = DatabaseStack(
    "databases",
    DatabaseStackArgs(
        postgres_enabled=True,
        redis_enabled=True
    )
)

# Deploy web servers
web = WebServerStack(
    "web",
    WebServerStackArgs(
        server_type="caddy",
        domains=["cloudcurio.cc"],
        ssl_enabled=True
    )
)

# Export outputs
export("network_id", network.network_id)
export("monitoring_enabled", True)
export("databases_enabled", True)
```

## Development

### Adding New Components

1. Create a new module in `cloudcurio-lib/`
2. Define Args class for component configuration
3. Create ComponentResource class
4. Add to `__init__.py`
5. Update documentation

Example:

```python
# cloudcurio_lib/mycomponent.py
from pulumi import ComponentResource, ResourceOptions

class MyComponentArgs:
    def __init__(self, name: str, enabled: bool = True):
        self.name = name
        self.enabled = enabled

class MyComponent(ComponentResource):
    def __init__(self, name: str, args: MyComponentArgs, opts=None):
        super().__init__('cloudcurio:custom:MyComponent', name, {}, opts)
        # Component logic here
        self.register_outputs({'name': args.name})
```

## Version History

- **0.1.0** (2024-01): Initial release
  - ZeroTier components
  - Monitoring components
  - Database components
  - Web server components

## License

MIT License - see LICENSE file

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Add tests for new components
4. Submit a pull request

## Support

- Issues: [GitHub Issues](https://github.com/cbwinslow/cloudcurio-infra/issues)
- Discussions: [GitHub Discussions](https://github.com/cbwinslow/cloudcurio-infra/discussions)
