"""
Pulumi Stack for Vercel deployment
Manages projects, deployments, and environment variables
"""

import pulumi
import pulumi_vercel as vercel
from pulumi import Config, Output

# Configuration
config = Config()
team_id = config.get("vercel_team_id")

# Vercel Project for CloudCurio Documentation
docs_project = vercel.Project("cloudcurio-docs",
    name="cloudcurio-docs",
    framework="nextjs",
    team_id=team_id,
    git_repository=vercel.ProjectGitRepositoryArgs(
        repo="cbwinslow/cloudcurio-docs",
        type="github",
        production_branch="main"
    ),
    build_command="npm run build",
    output_directory="out",
    install_command="npm install"
)

# Environment variables for the project
env_vars = [
    ("NODE_ENV", "production"),
    ("NEXT_PUBLIC_API_URL", "https://api.cloudcurio.cc"),
    ("NEXT_PUBLIC_SITE_URL", "https://cloudcurio.cc")
]

for key, value in env_vars:
    env_var = vercel.ProjectEnvironmentVariable(f"env-{key.lower().replace('_', '-')}",
        project_id=docs_project.id,
        team_id=team_id,
        key=key,
        value=value,
        targets=["production", "preview"]
    )

# Vercel Project for CloudCurio Dashboard
dashboard_project = vercel.Project("cloudcurio-dashboard",
    name="cloudcurio-dashboard",
    framework="react",
    team_id=team_id,
    git_repository=vercel.ProjectGitRepositoryArgs(
        repo="cbwinslow/cloudcurio-dashboard",
        type="github",
        production_branch="main"
    ),
    build_command="npm run build",
    output_directory="build",
    install_command="npm install"
)

# Domain configuration for docs
docs_domain = vercel.ProjectDomain("docs-domain",
    project_id=docs_project.id,
    team_id=team_id,
    domain="docs.cloudcurio.cc"
)

# Domain configuration for dashboard
dashboard_domain = vercel.ProjectDomain("dashboard-domain",
    project_id=dashboard_project.id,
    team_id=team_id,
    domain="dashboard.cloudcurio.cc"
)

# Vercel KV Store for caching
kv_store = vercel.Project("cloudcurio-cache",
    name="cloudcurio-cache-kv",
    framework="other",
    team_id=team_id
)

# Export values
pulumi.export("docs_project_id", docs_project.id)
pulumi.export("docs_url", Output.concat("https://", docs_domain.domain))
pulumi.export("dashboard_project_id", dashboard_project.id)
pulumi.export("dashboard_url", Output.concat("https://", dashboard_domain.domain))
