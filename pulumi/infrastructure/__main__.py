"""
CloudCurio Infrastructure Stack
Complete infrastructure deployment using CloudCurio Pulumi library
"""

import pulumi
from pulumi import Config, export
import sys
import os

# Add parent directory to path to import cloudcurio-lib
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from cloudcurio_lib.zerotier import ZeroTierNetwork, ZeroTierNodeArgs
from cloudcurio_lib.monitoring import MonitoringStack, MonitoringStackArgs
from cloudcurio_lib.database import DatabaseStack, DatabaseStackArgs
from cloudcurio_lib.web import WebServerStack, WebServerStackArgs

# Configuration
config = Config()

# ZeroTier Network Configuration
zerotier_nodes = [
    ZeroTierNodeArgs(
        hostname="cbwdellr720",
        ip_address="172.28.82.205",
        description="Dell R720 Server",
        tags={"type": "server", "role": "infrastructure"}
    ),
    ZeroTierNodeArgs(
        hostname="cbwhpz",
        ip_address="172.28.27.157",
        description="HP Workstation",
        tags={"type": "desktop", "role": "development"}
    ),
    ZeroTierNodeArgs(
        hostname="cbwamd",
        ip_address="172.28.176.115",
        description="AMD Desktop",
        tags={"type": "desktop", "role": "development"}
    ),
    ZeroTierNodeArgs(
        hostname="cbwlapkali",
        ip_address="172.28.196.74",
        description="Kali Laptop",
        tags={"type": "laptop", "role": "security"}
    ),
    ZeroTierNodeArgs(
        hostname="cbwmac",
        ip_address="172.28.169.48",
        description="Mac Desktop",
        tags={"type": "desktop", "role": "development"}
    ),
]

# Create ZeroTier Network
zerotier_network = ZeroTierNetwork(
    "cloudcurio-zt-network",
    args={
        'network_id': config.get('zerotier_network_id') or 'NETWORK_ID',
        'network_name': 'CloudCurio Network',
        'nodes': zerotier_nodes,
        'subnet': '172.28.0.0/16',
    }
)

# Create Monitoring Stack
monitoring = MonitoringStack(
    "cloudcurio-monitoring",
    MonitoringStackArgs(
        prometheus_enabled=True,
        grafana_enabled=True,
        loki_enabled=True,
        retention_days=90,
        scrape_interval="15s",
        targets=[node.ip_address for node in zerotier_nodes],
    )
)

# Create Database Stack
databases = DatabaseStack(
    "cloudcurio-databases",
    DatabaseStackArgs(
        postgres_enabled=True,
        mysql_enabled=False,
        redis_enabled=True,
        mongodb_enabled=False,
        postgres_version="15",
        redis_version="7",
    )
)

# Create Web Server Stack
web_servers = WebServerStack(
    "cloudcurio-web",
    WebServerStackArgs(
        server_type="caddy",
        domains=["cloudcurio.cc", "*.cloudcurio.cc"],
        ssl_enabled=True,
        http_port=80,
        https_port=443,
    )
)

# Export stack outputs
export("zerotier_network_id", zerotier_network.network_id)
export("zerotier_subnet", zerotier_network.subnet)
export("node_count", len(zerotier_nodes))
export("prometheus_port", 9090)
export("grafana_port", 3000)
export("loki_port", 3100)
export("monitoring_enabled", True)
export("databases_enabled", True)
export("web_servers_enabled", True)

# Export node information
node_info = {
    node.hostname: node.ip_address
    for node in zerotier_nodes
}
export("nodes", node_info)
