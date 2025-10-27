"""
Pulumi Stack for cloudcurio.cc on Cloudflare
Manages DNS, Workers, Pages, WAF, Access, and other Cloudflare services
"""

import pulumi
import pulumi_cloudflare as cloudflare
from pulumi import Config, Output

# Configuration
config = Config()
zone_name = config.get("zone_name") or "cloudcurio.cc"
account_id = config.require("cloudflare_account_id")

# Create or reference the zone
zone = cloudflare.Zone("cloudcurio-zone",
    account_id=account_id,
    zone=zone_name,
    plan="free",
    type="full"
)

# DNS Records for ZeroTier nodes
zerotier_nodes = {
    "cbwdellr720": "172.28.82.205",
    "cbwhpz": "172.28.27.157",
    "cbwamd": "172.28.176.115",
    "cbwlapkali": "172.28.196.74",
    "cbwmac": "172.28.169.48"
}

# Create A records for internal ZeroTier IPs (for reference)
for hostname, ip in zerotier_nodes.items():
    record = cloudflare.Record(f"{hostname}-zerotier",
        zone_id=zone.id,
        name=f"{hostname}.internal",
        type="A",
        value=ip,
        ttl=3600,
        comment=f"ZeroTier IP for {hostname}"
    )

# Cloudflare Access Application for internal services
access_app = cloudflare.AccessApplication("cloudcurio-internal",
    zone_id=zone.id,
    name="CloudCurio Internal Services",
    domain=f"internal.{zone_name}",
    type="self_hosted",
    session_duration="24h",
    auto_redirect_to_identity=True
)

# WAF Custom Rules
waf_rule = cloudflare.Ruleset("cloudcurio-waf",
    zone_id=zone.id,
    name="CloudCurio WAF Rules",
    description="Custom WAF rules for cloudcurio.cc",
    kind="zone",
    phase="http_request_firewall_custom",
    rules=[
        cloudflare.RulesetRuleArgs(
            action="block",
            expression='(http.request.uri.path contains "/admin" and not ip.geoip.country eq "US")',
            description="Block non-US access to admin",
        ),
        cloudflare.RulesetRuleArgs(
            action="challenge",
            expression='(cf.threat_score gt 10)',
            description="Challenge high threat score requests",
        )
    ]
)

# Cloudflare Workers for API endpoints
worker_script = cloudflare.WorkerScript("api-worker",
    account_id=account_id,
    name="cloudcurio-api",
    content="""
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  return new Response('CloudCurio API - Coming Soon', {
    headers: { 'content-type': 'text/plain' },
  })
}
"""
)

# Worker Route
worker_route = cloudflare.WorkerRoute("api-route",
    zone_id=zone.id,
    pattern=f"api.{zone_name}/*",
    script_name=worker_script.name
)

# Cloudflare Pages project
pages_project = cloudflare.PagesProject("cloudcurio-docs",
    account_id=account_id,
    name="cloudcurio-docs",
    production_branch="main",
    build_config=cloudflare.PagesProjectBuildConfigArgs(
        build_command="npm run build",
        destination_dir="dist",
        root_dir="/"
    ),
    deployment_configs=cloudflare.PagesProjectDeploymentConfigsArgs(
        production=cloudflare.PagesProjectDeploymentConfigsProductionArgs(
            compatibility_date="2024-01-01",
            compatibility_flags=["nodejs_compat"]
        )
    )
)

# Logpush job for analytics
logpush = cloudflare.LogpushJob("cloudcurio-logs",
    account_id=account_id,
    enabled=True,
    zone_id=zone.id,
    name="cloudcurio-http-requests",
    logpull_options="fields=ClientIP,ClientRequestHost,ClientRequestMethod,ClientRequestURI,EdgeEndTimestamp,EdgeResponseBytes,EdgeResponseStatus,EdgeStartTimestamp,RayID",
    destination_conf="s3://cloudcurio-logs?region=us-east-1",
    dataset="http_requests"
)

# Cloudflare Tunnel for secure access
tunnel = cloudflare.Tunnel("cloudcurio-tunnel",
    account_id=account_id,
    name="cloudcurio-infrastructure",
    secret=config.require_secret("tunnel_secret")
)

# Tunnel configuration
tunnel_config = cloudflare.TunnelConfig("tunnel-config",
    account_id=account_id,
    tunnel_id=tunnel.id,
    config=cloudflare.TunnelConfigConfigArgs(
        ingress_rules=[
            cloudflare.TunnelConfigConfigIngressRuleArgs(
                hostname=f"grafana.{zone_name}",
                service="http://localhost:3000"
            ),
            cloudflare.TunnelConfigConfigIngressRuleArgs(
                hostname=f"prometheus.{zone_name}",
                service="http://localhost:9090"
            ),
            cloudflare.TunnelConfigConfigIngressRuleArgs(
                service="http_status:404"
            )
        ]
    )
)

# Export values
pulumi.export("zone_id", zone.id)
pulumi.export("zone_name", zone.zone)
pulumi.export("tunnel_id", tunnel.id)
pulumi.export("tunnel_cname", tunnel.cname)
pulumi.export("pages_url", pages_project.subdomain)
pulumi.export("worker_url", Output.concat("https://api.", zone_name))
