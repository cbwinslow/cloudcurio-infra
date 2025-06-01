#!/usr/bin/env bash
###############################################################################
# Script Name:   setup_ubuntu_dev_env.sh
# Date:          2025-06-01
# Author:        ChatGPT (assistant to Blaine “CBW” Winslow)
#
# Summary:
#   This script automates the post-install configuration of an Ubuntu 
#   (22.04 or later) server/desktop to become a full-stack development 
#   environment as specified by Blaine Winslow. It installs and configures:
#     • Core utilities (git, curl, build tools)
#     • Docker Engine & NVIDIA Container Toolkit (if NVIDIA GPU detected)
#     • Podman (rootless)
#     • Docker Compose plugin
#     • Node.js (v18) + global npm packages (Apify, Coolify-CLI, Dify-CLI, 
#       Vercel, Replit, OpenAI-SDK, LangChain, Camel-Multiagent, etc.)
#     • Python 3.11 + pip + venv + AI frameworks (FastAPI, LangChain, Crewai, 
#       Camel-Multiagent, OpenAI, Ollama, GPT4All, ComfyUI placeholders, etc.)
#     • code-server (VS Code in browser) + preconfigured extension folder 
#       skeleton
#     • Warp .dev terminal (via official install script)
#     • Ansible + standard directory layout under ~/infra-ansible
#     • Caddy (latest) as a potential reverse proxy option
#     • Nginx (latest) for traditional reverse proxy / load balancing
#     • GitHub CLI
#     • OpenShift CLI (oc)
#     • Podman for rootless containers
#     • Basic security hardening: user in docker group, UFW firewall rules
#     • Placeholders for Dify, Coolify, ComfyUI, StableDiffusion-WebUI (actual 
#       setup via Docker Compose recommended after this)
#
# Inputs:
#   • None explicitly. This script assumes internet access and sudo privileges.
#   • GPU detection is automatic; if an NVIDIA GPU is present, NVIDIA drivers + 
#     container toolkit will be installed.
#
# Outputs:
#   • A configured Ubuntu machine with all necessary packages installed,
#     users/permissions set, and directories prepared.
#
# Parameters:
#   • None. All configuration is built-in. Adjust variables below if needed.
#
# Modification Log:
#   2025-06-01  CBW    Created initial version including full-stack tooling.
#
###############################################################################

set -euo pipefail
IFS=$'\n\t'

# ------------------------------------------------------------------------------
# Variables and Configuration
# ------------------------------------------------------------------------------

# Change these as needed:
DOMAIN="${DOMAIN:-cloudcurio.cc}"
LETSENCRYPT_EMAIL="${LETSENCRYPT_EMAIL:-blaine.winslow@gmail.com}"
ANSIBLE_INVENTORY_DIR="${HOME}/infra-ansible"

LOG_FILE="${HOME}/setup_ubuntu_dev_env.log"

# Package versions (pin as appropriate)
NODE_VERSION="18.x"
PYTHON_VERSION="3.11"
CODE_SERVER_VERSION="4.14.0"   # update if newer; ensure consistency
CADDY_REPO="deb [trusted=yes] https://dl.cloudsmith.io/public/caddy/stable/deb/ubuntu jammy main"
GITHUB_CLI_REPO="deb [arch=amd64] https://cli.github.com/packages stable main"

# ------------------------------------------------------------------------------
# Logging and Error-Handling Functions
# ------------------------------------------------------------------------------

log() {
    local ts
    ts="$(date +"%Y-%m-%d %H:%M:%S")"
    echo "[$ts] $*" | tee -a "${LOG_FILE}"
}

error_exit() {
    echo "ERROR: $*" | tee -a "${LOG_FILE}" >&2
    exit 1
}

# Ensure script is run with sudo/root privileges
if [[ "${EUID}" -ne 0 ]]; then
    error_exit "Please run as root or with sudo: sudo bash setup_ubuntu_dev_env.sh"
fi

log "Starting Ubuntu full-stack dev environment setup."

# ------------------------------------------------------------------------------
# Section 1: Pre-Flight Checks & Basic System Update
# ------------------------------------------------------------------------------

log "Updating APT package cache and upgrading existing packages..."
apt-get update -y >> "${LOG_FILE}" 2>&1
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y >> "${LOG_FILE}" 2>&1

# Ensure necessary base utilities are installed
log "Installing core utilities: git, curl, build-essential, software-properties-common, apt-transport-https..."
apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    unzip \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    lsb-release \
    jq \
    ufw \
    htop \
    net-tools >> "${LOG_FILE}" 2>&1

log "Core utilities installed."

# ------------------------------------------------------------------------------
# Section 2: Docker Engine & NVIDIA Container Toolkit
# ------------------------------------------------------------------------------

log "Installing Docker Engine..."

# 2.1 Add Docker official GPG key and repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# 2.2 Install Docker packages
apt-get update -y >> "${LOG_FILE}" 2>&1
apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io >> "${LOG_FILE}" 2>&1

# 2.3 Enable and start Docker service
systemctl enable docker.service >> "${LOG_FILE}" 2>&1
systemctl start docker.service >> "${LOG_FILE}" 2>&1

log "Docker Engine installed and running."

# 2.4 Add current non-root user(s) to docker group (if run as root via sudo, attempt adding the real user)
if [[ -n "${SUDO_USER:-}" ]]; then
    usermod -aG docker "${SUDO_USER}"
    log "Added ${SUDO_USER} to docker group."
fi

# 2.5 Detect NVIDIA GPU (using lspci) and install NVIDIA drivers and container toolkit if found
if lspci | grep -i "NVIDIA" &>/dev/null; then
    log "NVIDIA GPU detected. Installing NVIDIA drivers and container toolkit..."
    # 2.5.1 Add NVIDIA CUDA repo
    distribution="$(lsb_release -cs)"
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/${distribution}/x86_64/3bf863cc.pub | gpg --dearmor -o /usr/share/keyrings/nvidia-cuda-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/nvidia-cuda-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/${distribution}/x86_64/ /" \
      > /etc/apt/sources.list.d/nvidia-cuda.list

    # 2.5.2 Update and install NVIDIA driver and container toolkit
    apt-get update -y >> "${LOG_FILE}" 2>&1
    # Install recommended driver (e.g., nvidia-driver-515) and nvidia-docker2
    apt-get install -y --no-install-recommends \
        nvidia-driver-515 \
        nvidia-container-toolkit >> "${LOG_FILE}" 2>&1

    # 2.5.3 Configure Docker to use NVIDIA runtime by default
    mkdir -p /etc/docker
    cat > /etc/docker/daemon.json <<'EOF'
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
    systemctl restart docker.service >> "${LOG_FILE}" 2>&1
    log "NVIDIA drivers and container toolkit installed."
else
    log "No NVIDIA GPU detected. Skipping NVIDIA driver installation."
fi

# ------------------------------------------------------------------------------
# Section 3: Podman (Rootless) Installation
# ------------------------------------------------------------------------------

log "Installing Podman (rootless)..."
apt-get install -y --no-install-recommends podman >> "${LOG_FILE}" 2>&1
log "Podman installed."

# ------------------------------------------------------------------------------
# Section 4: Docker Compose Plugin Installation
# ------------------------------------------------------------------------------

log "Installing Docker Compose plugin..."
apt-get install -y --no-install-recommends docker-compose-plugin >> "${LOG_FILE}" 2>&1
log "Docker Compose plugin installed."

# ------------------------------------------------------------------------------
# Section 5: Node.js (v18) & Global npm Packages
# ------------------------------------------------------------------------------

log "Installing Node.js ${NODE_VERSION}..."

# 5.1 Add NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - >> "${LOG_FILE}" 2>&1

# 5.2 Install Node.js and npm
apt-get install -y --no-install-recommends nodejs >> "${LOG_FILE}" 2>&1

log "Node.js installed. Version: $(node -v), NPM: $(npm -v)"

# 5.3 Install global npm CLI tools
log "Installing global npm packages: apify, coolify-cli, dify-cli, vercel, replit, @openai/sdk, @langchain/langchain, camel-multiagent..."
npm install -g --no-progress \
    apify \
    coolify-cli \
    dify-cli \
    vercel \
    replit \
    @openai/sdk \
    @langchain/langchain \
    camel-multiagent >> "${LOG_FILE}" 2>&1

log "Global npm packages installed."

# ------------------------------------------------------------------------------
# Section 6: Python 3.11, pip, venv, and AI Framework Installation
# ------------------------------------------------------------------------------

log "Installing Python ${PYTHON_VERSION} and related packages..."

# 6.1 Add deadsnakes PPA for Python 3.11 if not already present
if ! apt-cache policy | grep -q "deadsnakes"; then
    add-apt-repository -y ppa:deadsnakes/ppa >> "${LOG_FILE}" 2>&1
    apt-get update -y >> "${LOG_FILE}" 2>&1
fi

# 6.2 Install Python 3.11 and pip
apt-get install -y --no-install-recommends \
    python3.11 \
    python3.11-venv \
    python3-pip \
    python3-distutils \
    libpq-dev \
    build-essential \
    libssl-dev \
    libffi-dev >> "${LOG_FILE}" 2>&1

log "Python installed. Version: $(python3.11 --version)"

# 6.3 Upgrade pip and install AI frameworks
log "Upgrading pip and installing Python AI/ML packages: fastapi, uvicorn, flask, django, pydantic, langchain, crewai, camel-multiagent, openai, openllm, torch, numpy, pandas..."
python3.11 -m pip install --upgrade pip wheel >> "${LOG_FILE}" 2>&1
python3.11 -m pip install --no-cache-dir \
    fastapi[all] \
    uvicorn[standard] \
    flask \
    django \
    pydantic \
    langchain \
    crewai \
    camel-multiagent \
    openai \
    openllm \
    torch \
    numpy \
    pandas >> "${LOG_FILE}" 2>&1

log "Python AI/ML packages installed."

# ------------------------------------------------------------------------------
# Section 7: code-server (VS Code in Browser) Installation
# ------------------------------------------------------------------------------

log "Installing code-server (VS Code in browser)..."

# 7.1 Download the latest .deb package
CODE_SERVER_DEB="code-server_${CODE_SERVER_VERSION}_amd64.deb"
wget -q "https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/${CODE_SERVER_DEB}" -O "/tmp/${CODE_SERVER_DEB}" || \
    error_exit "Failed to download code-server .deb"

# 7.2 Install code-server
dpkg -i "/tmp/${CODE_SERVER_DEB}" >> "${LOG_FILE}" 2>&1 || apt-get install -f -y >> "${LOG_FILE}" 2>&1

# 7.3 Enable and start code-server as a systemd service (runs under user 'coder')
if id "coder" &>/dev/null; then
    log "User 'coder' already exists."
else
    useradd -m -s /usr/bin/bash coder
    log "Created user 'coder' for code-server."
fi

# Create default config folder if missing
sudo -u coder mkdir -p /home/coder/.config/code-server

# Copy default systemd unit (code-server installs this by default)
systemctl enable --now code-server@$(( SUDO_USER:-coder )).service >> "${LOG_FILE}" 2>&1 || log "Warning: code-server service enable/start may have issues."

log "code-server installation complete. Access via: http://<server-ip>:8080 (default port)."

# ------------------------------------------------------------------------------
# Section 8: Warp .dev Terminal Installation
# ------------------------------------------------------------------------------

log "Installing Warp .dev terminal..."

# Warp’s official install script (handles latest Debian/Ubuntu)
wget -qO- https://api.warp.dev/install.sh | bash >> "${LOG_FILE}" 2>&1 || \
    error_exit "Warp installation failed."

log "Warp terminal installed. You may need to log out and log back in to launch Warp."

# ------------------------------------------------------------------------------
# Section 9: Ansible Installation & Directory Layout
# ------------------------------------------------------------------------------

log "Installing Ansible and setting up standard directory layout under ${ANSIBLE_INVENTORY_DIR}..."

# 9.1 Install Ansible
apt-get install -y --no-install-recommends ansible >> "${LOG_FILE}" 2>&1

# 9.2 Create Ansible directory structure
mkdir -p "${ANSIBLE_INVENTORY_DIR}"/{playbooks,roles,files,templates,collections,inventories/{lab/{group_vars,host_vars},prod/{group_vars,host_vars}}}
cat > "${ANSIBLE_INVENTORY_DIR}/ansible.cfg" <<'EOF'
[defaults]
inventory = ./inventories/lab
host_key_checking = False
retry_files_enabled = False
deprecation_warnings=False
EOF

log "Ansible installed. Directory structure created at ${ANSIBLE_INVENTORY_DIR}."

# ------------------------------------------------------------------------------
# Section 10: Caddy Reverse Proxy Installation
# ------------------------------------------------------------------------------

log "Installing Caddy (latest)..."

# 10.1 Add Caddy apt repository
if ! grep -q "dl.cloudsmith.io/public/caddy/stable" /etc/apt/sources.list.d/caddy-stable.list 2>/dev/null; then
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    echo "${CADDY_REPO}" > /etc/apt/sources.list.d/caddy-stable.list
fi

apt-get update -y >> "${LOG_FILE}" 2>&1
apt-get install -y --no-install-recommends caddy >> "${LOG_FILE}" 2>&1

log "Caddy installed. Default Caddyfile at /etc/caddy/Caddyfile."

# ------------------------------------------------------------------------------
# Section 11: Nginx Reverse Proxy Installation
# ------------------------------------------------------------------------------

log "Installing Nginx..."

apt-get install -y --no-install-recommends nginx >> "${LOG_FILE}" 2>&1
systemctl enable nginx.service >> "${LOG_FILE}" 2>&1
systemctl start nginx.service >> "${LOG_FILE}" 2>&1

log "Nginx installed and running."

# ------------------------------------------------------------------------------
# Section 12: GitHub CLI Installation
# ------------------------------------------------------------------------------

log "Installing GitHub CLI..."

# 12.1 Add GitHub CLI apt repository
if ! grep -q "cli.github.com" /etc/apt/sources.list.d/github-cli.list 2>/dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "${GITHUB_CLI_REPO}" > /etc/apt/sources.list.d/github-cli.list
fi

apt-get update -y >> "${LOG_FILE}" 2>&1
apt-get install -y --no-install-recommends gh >> "${LOG_FILE}" 2>&1

log "GitHub CLI installed. Version: $(gh --version)"

# ------------------------------------------------------------------------------
# Section 13: OpenShift CLI (oc) Installation
# ------------------------------------------------------------------------------

log "Installing OpenShift CLI (oc)..."

# 13.1 Determine latest stable release (hardcoded or fetched dynamically)
OC_VERSION="4.13.0"
ARCH=$(uname -m | sed 's/x86_64/amd64/')
OC_TAR="openshift-client-linux-${OC_VERSION}-${ARCH}.tar.gz"

# 13.2 Download and extract
wget -q "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/${OC_TAR}" -O "/tmp/${OC_TAR}" || \
    error_exit "Failed to download OpenShift CLI."
tar -C /tmp -xzf "/tmp/${OC_TAR}"
mv /tmp/oc /usr/local/bin/oc
chmod +x /usr/local/bin/oc
rm "/tmp/${OC_TAR}"
log "OpenShift CLI installed. Version: $(oc version | head -n1)"

# ------------------------------------------------------------------------------
# Section 14: Additional CLI Tools & SDKs
# ------------------------------------------------------------------------------

log "Installing additional CLI tools and SDKs..."

# 14.1 Apify, Dify, Coolify already installed via npm in Section 5

# 14.2 Install Replit & Vercel CLI (already via npm)
#        (If new versions are needed, `npm update -g replit vercel`.)

# 14.3 Install OpenAI Python SDK (already via pip)
#        (pip install openai — covered in Section 6)

# 14.4 Install Ollama (official .deb or brew alternative)
log "Installing Ollama CLI..."
curl -fsSL https://ollama.ai/install.sh | bash >> "${LOG_FILE}" 2>&1 || log "Warning: Ollama install script may have failed."

# 14.5 Install GPT4All (via pip)
log "Installing GPT4All..."
python3.11 -m pip install --no-cache-dir gpt4all >> "${LOG_FILE}" 2>&1 || log "Warning: GPT4All pip install may have errors."

# 14.6 Install Camel-Multiagent (already via pip)
# 14.7 Install Crewai (already via pip)
# 14.8 Install LangChain (already via pip)
# 14.9 Install LangSmith, Langraph via pip (if available on PyPI)
python3.11 -m pip install --no-cache-dir langsmith langraph >> "${LOG_FILE}" 2>&1 || log "Warning: langsmith/langraph install may have warnings."

# 14.10 Install ComfyUI / StableDiffusion-WebUI placeholders
#    Note: Full setups require GPU and large model downloads; we recommend using Docker Compose for these.
log "Installing placeholders for ComfyUI/StableDiffusion-WebUI prerequisites..."
python3.11 -m pip install --no-cache-dir comfyui stable-diffusion-webui >> "${LOG_FILE}" 2>&1 || log "Warning: ComfyUI/StableDiffusion pip install may fail (requires extra system libs)."

# ------------------------------------------------------------------------------
# Section 15: Dify, Coolify, Jira, Bitbucket Placeholders
# ------------------------------------------------------------------------------

cat <<'INFO' | tee -a "${LOG_FILE}"
--------------------------------------------------------------------------------
Placeholders for Dify, Coolify, Jira, and Bitbucket:
  • These services are recommended to run as Docker containers via Docker Compose,
    since full server setup often requires volumes, environment variables, and 
    specific configs. After this script, create a docker-compose.yml (per earlier 
    guidelines) to deploy Dify, Coolify, Jira, and Bitbucket.
--------------------------------------------------------------------------------
INFO

# ------------------------------------------------------------------------------
# Section 16: Firewall (UFW) Setup
# ------------------------------------------------------------------------------

log "Configuring UFW firewall: allowing SSH (22), HTTP (80), HTTPS (443), and code-server (8080)..."
ufw allow 22/tcp comment 'SSH' >> "${LOG_FILE}" 2>&1
ufw allow 80/tcp comment 'HTTP' >> "${LOG_FILE}" 2>&1
ufw allow 443/tcp comment 'HTTPS' >> "${LOG_FILE}" 2>&1
ufw allow 8080/tcp comment 'code-server' >> "${LOG_FILE}" 2>&1
ufw --force enable >> "${LOG_FILE}" 2>&1
log "UFW configured and enabled."

# ------------------------------------------------------------------------------
# Section 17: Final Notes & Next Steps
# ------------------------------------------------------------------------------

cat <<'CONGRATS'

===============================================
Ubuntu Full-Stack Dev Environment Setup Complete!
===============================================

Next Steps:
  1. **Reboot** your machine to ensure all kernel modules (especially NVIDIA) 
     and systemd services start cleanly:
       sudo reboot

  2. **Verify Docker + NVIDIA**:
       docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

  3. **Login to code-server**:
       Visit: http://<your-server-ip>:8080
       Default user: coder
       Set a password by editing: /home/coder/.config/code-server/config.yaml

  4. **Clone or create your Git repositories** under ~/workspace.  
     Example:
       mkdir -p ~/workspace && cd ~/workspace
       git clone https://bitbucket.org/your_repo.git

  5. **Create Docker Compose stack** to launch:
       • Redis, PostgreSQL  
       • Dify, Coolify  
       • FastAPI (your Python back-end)  
       • ComfyUI, SD WebUI (GPU-enabled)  
       • Traefik/Caddy (reverse proxy)  
       • Jira, Bitbucket (if self-hosted)  
     Reference the earlier provided docker-compose.yml template.

  6. **Configure Ansible inventory** at ~/infra-ansible/inventories/lab or prod  
     to manage additional provisioning for other hosts (if you have more than one).

  7. **Install VS Code extensions** by copying your `extensions.json` to:  
       /home/coder/.local/share/code-server/User/extensions.json  

  8. **Customize Caddy or Nginx** by editing:  
       • /etc/caddy/Caddyfile  
       • /etc/nginx/sites-available/default  

  9. **Secure secrets**:
       Use Docker secrets (for Postgres, Redis, etc.) or HashiCorp Vault (future step).

10. **Set up GitHub/Bitbucket Pipelines** and register with Coolify for auto-deploy.

-------------------------------------------------------------------------------
Enjoy your beefy, all-in-one Ubuntu dev environment! Happy coding, CBW! 😎
-------------------------------------------------------------------------------

CONGRATS

# ------------------------------------------------------------------------------
# Three (3) Possible Improvements / Next Steps
# ------------------------------------------------------------------------------

cat <<'IMPROVEMENTS' | tee -a "${LOG_FILE}"

1) **Modular Docker-Compose Orchestration**  
   • Rather than running all services on the host, create a Docker Compose 
     directory (`~/workspace/docker-compose`) that defines each service (FastAPI, 
     Dify, Coolify, ComfyUI, SD WebUI, Jira, Bitbucket, Traefik, Redis, Postgres).  
   • This modular approach isolates dependencies, makes upgrades easier, and 
     enables per-service resource limits (e.g., memory, CPU, GPUs).

2) **GitOps with Ansible & Helm for Kubernetes**  
   • If you outgrow Docker Compose, spin up a single-node k3s cluster on this 
     Ubuntu box (k3s is lightweight).  
   • Convert your Docker Compose YAML into Helm charts (there are tools like 
     kompose).  
   • Use Ansible playbooks to deploy/upgrade each Helm chart, tying into your 
     existing ~/infra-ansible layout. This provides declarative GitOps: pushing 
     to Git → Ansible tags → ArgoCD/Flux sync.

3) **Centralized Secrets Management & Vault Integration**  
   • Right now, credentials (Postgres, Redis, API keys) are stored in .env or 
     plaintext files. For enhanced security, install HashiCorp Vault (or cloud 
     equivalent).  
   • Update your Ansible playbooks to fetch secrets at runtime and inject into 
     containers or configuration files. This way, no plain secrets ever touch 
     disk, and you gain auditing, versioning, and dynamic revocation.

IMPROVEMENTS

# ------------------------------------------------------------------------------
# End of setup_ubuntu_dev_env.sh
# ------------------------------------------------------------------------------
