provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_zone" "main" {
  zone = "cloudcurio.cc"
}

resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.main.id
  name    = "www"
  value   = var.backend_ip_address
  type    = "A"
  ttl     = 300
  proxied = true
}

resource "cloudflare_record" "root" {
  zone_id = cloudflare_zone.main.id
  name    = "@"
  value   = var.backend_ip_address
  type    = "A"
  ttl     = 300
  proxied = true
}
