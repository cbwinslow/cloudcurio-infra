output "zone_id" {
  description = "Cloudflare Zone ID"
  value       = cloudflare_zone.main.id
}

output "zone_name" {
  description = "Cloudflare Zone Name"
  value       = cloudflare_zone.main.zone
}

output "tunnel_id" {
  description = "Cloudflare Tunnel ID"
  value       = cloudflare_tunnel.main.id
}

output "tunnel_cname" {
  description = "Cloudflare Tunnel CNAME"
  value       = cloudflare_tunnel.main.cname
}

output "pages_domains" {
  description = "Cloudflare Pages domains"
  value       = cloudflare_pages_project.docs.domains
}

output "zerotier_dns_records" {
  description = "DNS records created for ZeroTier nodes"
  value = {
    for k, v in cloudflare_record.zerotier_nodes : k => {
      hostname = v.hostname
      value    = v.value
    }
  }
}
