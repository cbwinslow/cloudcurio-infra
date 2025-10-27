terraform {
  required_version = ">= 1.0"
  
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Cloudflare Zone
resource "cloudflare_zone" "main" {
  account_id = var.cloudflare_account_id
  zone       = var.zone_name
  plan       = "free"
  type       = "full"
}

# DNS Records for ZeroTier nodes (dynamic loop)
resource "cloudflare_record" "zerotier_nodes" {
  for_each = var.zerotier_nodes

  zone_id = cloudflare_zone.main.id
  name    = "${each.key}.internal"
  value   = each.value
  type    = "A"
  ttl     = 3600
  comment = "ZeroTier IP for ${each.key}"
}

# Cloudflare Tunnel
resource "cloudflare_tunnel" "main" {
  account_id = var.cloudflare_account_id
  name       = "cloudcurio-infrastructure"
  secret     = var.tunnel_secret
}

# Tunnel configuration
resource "cloudflare_tunnel_config" "main" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_tunnel.main.id

  config {
    ingress_rule {
      hostname = "grafana.${var.zone_name}"
      service  = "http://localhost:3000"
    }
    
    ingress_rule {
      hostname = "prometheus.${var.zone_name}"
      service  = "http://localhost:9090"
    }

    ingress_rule {
      hostname = "loki.${var.zone_name}"
      service  = "http://localhost:3100"
    }

    ingress_rule {
      hostname = "anythingllm.${var.zone_name}"
      service  = "http://localhost:3001"
    }

    ingress_rule {
      service = "http_status:404"
    }
  }
}

# WAF Rules
resource "cloudflare_ruleset" "waf" {
  zone_id     = cloudflare_zone.main.id
  name        = "CloudCurio WAF Rules"
  description = "Custom WAF rules for cloudcurio.cc"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules {
    action      = "block"
    expression  = "(http.request.uri.path contains \"/admin\" and not ip.geoip.country eq \"US\")"
    description = "Block non-US access to admin"
    enabled     = true
  }

  rules {
    action      = "challenge"
    expression  = "(cf.threat_score gt 10)"
    description = "Challenge high threat score requests"
    enabled     = true
  }
}

# Cloudflare Access Application
resource "cloudflare_access_application" "internal" {
  zone_id                   = cloudflare_zone.main.id
  name                      = "CloudCurio Internal Services"
  domain                    = "internal.${var.zone_name}"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = true
}

# Cloudflare Pages Project
resource "cloudflare_pages_project" "docs" {
  account_id        = var.cloudflare_account_id
  name              = "cloudcurio-docs"
  production_branch = "main"

  build_config {
    build_command       = "npm run build"
    destination_dir     = "dist"
    root_dir            = "/"
  }

  deployment_configs {
    production {
      compatibility_date  = "2024-01-01"
      compatibility_flags = ["nodejs_compat"]
    }
  }
}
