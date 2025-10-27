variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "zone_name" {
  description = "Domain name"
  type        = string
  default     = "cloudcurio.cc"
}

variable "tunnel_secret" {
  description = "Cloudflare Tunnel secret"
  type        = string
  sensitive   = true
}

variable "zerotier_nodes" {
  description = "Map of ZeroTier nodes and their IPs (dynamically expandable)"
  type        = map(string)
  default = {
    cbwdellr720 = "172.28.82.205"
    cbwhpz      = "172.28.27.157"
    cbwamd      = "172.28.176.115"
    cbwlapkali  = "172.28.196.74"
    cbwmac      = "172.28.169.48"
  }
}
