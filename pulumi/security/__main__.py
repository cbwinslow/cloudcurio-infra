"""
CloudCurio Security Stack
Manages security infrastructure including WAF, Access, and security policies
"""

import pulumi
import pulumi_cloudflare as cloudflare
from pulumi import Config, export

# Configuration
config = Config()
zone_name = config.get("zone_name") or "cloudcurio.cc"
account_id = config.require("cloudflare_account_id")

# Get zone
zone = cloudflare.get_zone(name=zone_name)

# WAF Custom Rules
waf_rules = cloudflare.Ruleset("cloudcurio-waf",
    zone_id=zone.id,
    name="CloudCurio WAF Rules",
    description="Security rules for CloudCurio infrastructure",
    kind="zone",
    phase="http_request_firewall_custom",
    rules=[
        # Block non-US access to admin paths
        cloudflare.RulesetRuleArgs(
            action="block",
            expression='(http.request.uri.path contains "/admin" and not ip.geoip.country eq "US")',
            description="Block non-US access to admin paths",
            enabled=True,
        ),
        # Challenge high threat score requests
        cloudflare.RulesetRuleArgs(
            action="challenge",
            expression='(cf.threat_score gt 10)',
            description="Challenge high threat score requests",
            enabled=True,
        ),
        # Block known bot patterns
        cloudflare.RulesetRuleArgs(
            action="block",
            expression='(cf.bot_management.score lt 30)',
            description="Block requests from known bad bots",
            enabled=True,
        ),
        # Rate limiting for API endpoints
        cloudflare.RulesetRuleArgs(
            action="challenge",
            expression='(http.request.uri.path contains "/api/" and rate.http.request.uri gt 100)',
            description="Rate limit API endpoints",
            enabled=True,
        ),
    ]
)

# Cloudflare Access Application for internal services
access_app = cloudflare.AccessApplication("cloudcurio-internal",
    zone_id=zone.id,
    name="CloudCurio Internal Services",
    domain=f"internal.{zone_name}",
    type="self_hosted",
    session_duration="24h",
    auto_redirect_to_identity=True,
    allowed_idps=["email"],
)

# Access Policy - Email-based authentication
access_policy = cloudflare.AccessPolicy("internal-policy",
    application_id=access_app.id,
    zone_id=zone.id,
    name="Email Authentication",
    precedence=1,
    decision="allow",
    includes=[
        cloudflare.AccessPolicyIncludeArgs(
            email_domain=cloudflare.AccessPolicyIncludeEmailDomainArgs(
                domain="cloudcurio.cc"
            )
        )
    ]
)

# Page Rules for security headers
page_rule_security_headers = cloudflare.PageRule("security-headers",
    zone_id=zone.id,
    target=f"*.{zone_name}/*",
    actions=cloudflare.PageRuleActionsArgs(
        security_level="high",
        ssl="strict",
        always_use_https=True,
    ),
    priority=1,
)

# Rate limiting rule
rate_limit = cloudflare.RateLimit("api-rate-limit",
    zone_id=zone.id,
    threshold=100,
    period=60,
    match=cloudflare.RateLimitMatchArgs(
        request=cloudflare.RateLimitMatchRequestArgs(
            url_pattern=f"{zone_name}/api/*"
        )
    ),
    action=cloudflare.RateLimitActionArgs(
        mode="challenge",
        timeout=3600,
    ),
    description="Rate limit for API endpoints"
)

# Export outputs
export("zone_id", zone.id)
export("waf_ruleset_id", waf_rules.id)
export("access_app_id", access_app.id)
export("rate_limit_id", rate_limit.id)
