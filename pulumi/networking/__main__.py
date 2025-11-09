"""
CloudCurio Networking Stack
Manages networking infrastructure including DNS, tunnels, and VPN
"""

import pulumi
import pulumi_cloudflare as cloudflare
from pulumi import Config, export

# Configuration
config = Config()
zone_name = config.get("zone_name") or "cloudcurio.cc"
account_id = config.get("cloudflare_account_id")

# ZeroTier nodes configuration
zerotier_nodes = {
    "cbwdellr720": "172.28.82.205",
    "cbwhpz": "172.28.27.157",
    "cbwamd": "172.28.176.115",
    "cbwlapkali": "172.28.196.74",
    "cbwmac": "172.28.169.48"
}

# Create or reference the Cloudflare zone
if account_id:
    zone = cloudflare.Zone("cloudcurio-zone",
        account_id=account_id,
        zone=zone_name,
        plan="free",
        type="full"
    )
    zone_id = zone.id
else:
    # Use existing zone if account_id not provided
    zone = cloudflare.get_zone(name=zone_name)
    zone_id = zone.id

# Create DNS A records for internal ZeroTier IPs
zerotier_records = {}
for hostname, ip in zerotier_nodes.items():
    record = cloudflare.Record(f"{hostname}-internal",
        zone_id=zone_id,
        name=f"{hostname}.internal",
        type="A",
        value=ip,
        ttl=3600,
        comment=f"ZeroTier internal IP for {hostname}"
    )
    zerotier_records[hostname] = record

# Create Cloudflare Tunnel for secure access
tunnel_secret = config.get_secret("tunnel_secret")
if tunnel_secret:
    tunnel = cloudflare.Tunnel("cloudcurio-tunnel",
        account_id=account_id,
        name="cloudcurio-infrastructure",
        secret=tunnel_secret
    )
    
    # Configure tunnel ingress rules
    tunnel_config = cloudflare.TunnelConfig("tunnel-config",
        account_id=account_id,
        tunnel_id=tunnel.id,
        config=cloudflare.TunnelConfigConfigArgs(
            ingress_rules=[
                cloudflare.TunnelConfigConfigIngressRuleArgs(
                    hostname=f"grafana.{zone_name}",
                    service="http://172.28.82.205:3000"
                ),
                cloudflare.TunnelConfigConfigIngressRuleArgs(
                    hostname=f"prometheus.{zone_name}",
                    service="http://172.28.82.205:9090"
                ),
                cloudflare.TunnelConfigConfigIngressRuleArgs(
                    hostname=f"loki.{zone_name}",
                    service="http://172.28.82.205:3100"
                ),
                cloudflare.TunnelConfigConfigIngressRuleArgs(
                    hostname=f"anythingllm.{zone_name}",
                    service="http://172.28.82.205:3001"
                ),
                cloudflare.TunnelConfigConfigIngressRuleArgs(
                    service="http_status:404"
                )
            ]
        )
    )
    
    # Create DNS records for tunnel services
    tunnel_services = ["grafana", "prometheus", "loki", "anythingllm"]
    for service in tunnel_services:
        cloudflare.Record(f"{service}-tunnel",
            zone_id=zone_id,
            name=service,
            type="CNAME",
            value=tunnel.cname,
            ttl=1,
            proxied=True,
            comment=f"Cloudflare Tunnel for {service}"
        )

# Export outputs
export("zone_id", zone_id)
export("zone_name", zone_name)
export("zerotier_nodes", zerotier_nodes)
if tunnel_secret:
    export("tunnel_id", tunnel.id)
    export("tunnel_cname", tunnel.cname)
