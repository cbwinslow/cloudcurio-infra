# Infrastructure as Code - Pulumi & Terraform

This directory contains Infrastructure as Code (IaC) configurations for deploying cloudcurio.cc infrastructure on Cloudflare and Vercel using both Pulumi and Terraform.

## Directory Structure

```
.
├── pulumi/
│   ├── cloudflare/       # Pulumi stack for Cloudflare
│   │   ├── __main__.py
│   │   ├── Pulumi.yaml
│   │   └── requirements.txt
│   └── vercel/           # Pulumi stack for Vercel
│       ├── __main__.py
│       ├── Pulumi.yaml
│       └── requirements.txt
└── terraform/
    └── cloudflare/       # Terraform configuration for Cloudflare
        ├── main.tf
        ├── variables.tf
        └── output.tf
```

## Pulumi Stacks

### Cloudflare Stack

Manages comprehensive Cloudflare infrastructure including:
- **DNS Zone** for cloudcurio.cc
- **DNS Records** for ZeroTier nodes (dynamically looped)
- **Cloudflare Tunnel** for secure access to internal services
- **WAF Rules** for security
- **Access Application** for authentication
- **Workers** for API endpoints
- **Pages** for static site hosting
- **Logpush** for analytics

#### Setup

```bash
cd pulumi/cloudflare
pip install -r requirements.txt
pulumi login
pulumi stack init cloudcurio-prod
pulumi config set cloudflare:apiToken YOUR_TOKEN --secret
pulumi config set cloudflare_account_id YOUR_ACCOUNT_ID
pulumi config set tunnel_secret YOUR_TUNNEL_SECRET --secret
pulumi up
```

#### Features

- **Dynamic ZeroTier DNS**: Automatically creates DNS records for all ZeroTier nodes
- **Tunnel Configuration**: Exposes Grafana, Prometheus, Loki, and AnythingLLM
- **Security**: WAF rules, geo-blocking, threat score challenges
- **Observability**: Logpush integration for request logging

### Vercel Stack

Manages Vercel deployments:
- **Projects** for documentation and dashboard
- **Environment Variables** configuration
- **Domain Mappings** for custom domains
- **KV Store** for caching

#### Setup

```bash
cd pulumi/vercel
pip install -r requirements.txt
pulumi login
pulumi stack init cloudcurio-prod
pulumi config set vercel:apiToken YOUR_TOKEN --secret
pulumi config set vercel_team_id YOUR_TEAM_ID
pulumi up
```

## Terraform Configuration

### Cloudflare

Terraform alternative for Cloudflare infrastructure with same features as Pulumi stack.

#### Setup

```bash
cd terraform/cloudflare
terraform init
terraform plan -var="cloudflare_api_token=YOUR_TOKEN" \
               -var="cloudflare_account_id=YOUR_ACCOUNT_ID" \
               -var="tunnel_secret=YOUR_SECRET"
terraform apply
```

#### Features

- **Dynamic Looping**: Uses `for_each` to iterate over ZeroTier nodes
- **Modular**: Easy to add new nodes by updating `zerotier_nodes` variable
- **State Management**: Supports remote state in S3

## Adding New ZeroTier Nodes

### Pulumi

Update the `zerotier_nodes` dictionary in `pulumi/cloudflare/__main__.py`:

```python
zerotier_nodes = {
    "cbwdellr720": "172.28.82.205",
    "cbwhpz": "172.28.27.157",
    "cbwamd": "172.28.176.115",
    "cbwlapkali": "172.28.196.74",
    "cbwmac": "172.28.169.48",
    "newnode": "172.28.x.x"  # Add new node here
}
```

Then run `pulumi up` to apply changes.

### Terraform

Update the `zerotier_nodes` variable in `terraform/cloudflare/variables.tf`:

```hcl
variable "zerotier_nodes" {
  default = {
    cbwdellr720 = "172.28.82.205"
    cbwhpz      = "172.28.27.157"
    cbwamd      = "172.28.176.115"
    cbwlapkali  = "172.28.196.74"
    cbwmac      = "172.28.169.48"
    newnode     = "172.28.x.x"  # Add new node here
  }
}
```

Then run `terraform apply` to update infrastructure.

## Cloudflare Platform Features

### MCP Servers (Model Context Protocol)

Cloudflare Workers can be used to implement MCP servers:

```javascript
// Example MCP server in Cloudflare Worker
addEventListener('fetch', event => {
  event.respondWith(handleMCP(event.request))
})

async function handleMCP(request) {
  // MCP protocol implementation
  const mcp = await request.json()
  // Process MCP request
  return new Response(JSON.stringify(response), {
    headers: { 'content-type': 'application/json' }
  })
}
```

### WAF (Web Application Firewall)

Configured with custom rules:
- Geographic restrictions (e.g., US-only admin access)
- Threat score challenges
- Rate limiting
- Custom firewall rules

### Tunnels

Cloudflare Tunnels provide secure access to internal services without exposing ports:
- Grafana: `grafana.cloudcurio.cc`
- Prometheus: `prometheus.cloudcurio.cc`
- Loki: `loki.cloudcurio.cc`
- AnythingLLM: `anythingllm.cloudcurio.cc`

### Access

Zero Trust security with Cloudflare Access:
- Email-based authentication
- Session management
- Audit logs

### Pages

Static site hosting with:
- Automatic builds from GitHub
- Custom domains
- Preview deployments
- Edge rendering

### Workers

Serverless functions for:
- API endpoints
- Edge computing
- Request manipulation
- MCP server implementation

### Observability

- Logpush to S3 for log aggregation
- Real-time analytics
- Security insights
- Performance monitoring

## Vercel Platform Features

### Projects

Automated deployments from GitHub with:
- Production and preview environments
- Build optimization
- Edge network deployment

### Environment Variables

Managed environment variables for:
- API keys
- Feature flags
- Configuration

### Serverless Functions

API routes and serverless functions with:
- Automatic scaling
- Edge network distribution
- Zero configuration

### Edge Network

Global CDN with:
- Automatic optimization
- Image optimization
- Compression

## Best Practices

1. **Secret Management**: Always use `--secret` flag for sensitive values
2. **State Management**: Use remote state (Pulumi Cloud or S3 for Terraform)
3. **Version Control**: Keep IaC in version control, exclude secrets
4. **Testing**: Test changes in preview/staging environment first
5. **Documentation**: Document all infrastructure changes
6. **Loops**: Use dynamic loops for scalability (adding new nodes)

## Outputs

Both Pulumi and Terraform export useful outputs:

```bash
# Pulumi
pulumi stack output zone_id
pulumi stack output tunnel_cname

# Terraform
terraform output zone_id
terraform output tunnel_cname
```

## Integration with Ansible

The IaC configurations work alongside Ansible playbooks:

1. **IaC** provisions cloud infrastructure (DNS, tunnels, WAF)
2. **Ansible** configures servers and installs software
3. **Both** use the same ZeroTier IP mappings for consistency

## Support

For issues or questions:
- Pulumi: https://www.pulumi.com/docs/
- Terraform: https://registry.terraform.io/providers/cloudflare/cloudflare/
- Cloudflare: https://developers.cloudflare.com/
- Vercel: https://vercel.com/docs
