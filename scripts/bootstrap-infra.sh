#!/usr/bin/env bash
###############################################################################
# Script Name:   bootstrap_infrastructure.sh
# Date:          2025-06-01
# Author:        ChatGPT (for Blaine “CBW” Winslow)
#
# Summary:
#   Clones the specified GitHub repository containing Terraform modules and
#   Ansible playbooks, then provisions infrastructure with Terraform and
#   configures it with Ansible as per the repository’s instructions.
#
#   This script:
#     1. Validates prerequisites (git, terraform, ansible).
#     2. Clones (or updates) the GitHub repo to a local directory.
#     3. Exports required environment variables (DigitalOcean token, Cloudflare
#        credentials, SSH key path, etc.).
#     4. Runs Terraform in the chosen environment (prod by default), creating
#        VMs and DNS records.
#     5. Generates an Ansible inventory from Terraform outputs.
#     6. Runs the top-level Ansible playbook to install and configure all
#        services (Docker, Vault, Traefik, code-server, etc.).
#
# Inputs:
#   • GITHUB_REPO_URL         – URL of the GitHub repository (e.g.
#                                https://github.com/YourUser/infra.git)
#   • TARGET_DIR              – Absolute or relative path to clone into
#                                (default: ./infra)
#   • TF_ENV                  – Terraform environment subdirectory (prod/staging;
#                                default: prod)
#   • SSH_KEY_PATH            – Path to SSH public key used by Terraform
#                                (default: ~/.ssh/id_ed25519.pub)
#   • DO_TOKEN                – DigitalOcean API token (export as env var or
#                                set in terraform.tfvars)
#   • CLOUDFLARE_EMAIL        – Cloudflare account email (export as env var)
#   • CLOUDFLARE_API_TOKEN    – Cloudflare API token (export as env var)
#   • CLOUDFLARE_ZONE         – Cloudflare DNS zone (e.g. “cloudcurio.cc”)
#   • INITIAL_PASSWORD_HASH   – SHA-512 hash for initial “cbwinslow” user
#                                on the VM (export as env var)
#
# Outputs:
#   • Terraform will create:
#       – A DigitalOcean droplet (Ubuntu 22.04)
#       – A Cloudflare DNS A record pointing “vault.*” to that droplet
#   • Ansible will configure:
#       – Docker, NVIDIA runtime, Podman, Docker Compose
#       – Node.js, Python, code-server, Warp, Caddy, Nginx, CLI tools
#       – UFW firewall, Vault (dev mode), Vaultwarden, Traefik, etc.
#
# Parameters:
#   REPO_URL         – Derived from GITHUB_REPO_URL
#   CLONE_DIR        – TARGET_DIR/repo_name
#   TF_DIR           – CLONE_DIR/terraform/environments/${TF_ENV}
#   ANSIBLE_DIR      – CLONE_DIR/ansible
#   INV_FILE         – ANSIBLE_DIR/inventories/${TF_ENV}/hosts.ini
#
# Modification Log:
#   2025-06-01  CBW    Created initial version to automate GitHub clone + Terraform +
#                      Ansible provisioning.
#
###############################################################################

set -euo pipefail
IFS=$'\n\t'

# ------------------------------------------------------------------------------
# Configuration & Default Variables
# ------------------------------------------------------------------------------
REPO_URL="${GITHUB_REPO_URL:-}"
TARGET_DIR="${TARGET_DIR:-./infra}"
TF_ENV="${TF_ENV:-prod}"
SSH_KEY_PATH="${SSH_KEY_PATH:-${HOME}/.ssh/id_ed25519.pub}"
LOG_FILE="${TARGET_DIR}/bootstrap_infra.log"

# ------------------------------------------------------------------------------
# Helper Functions
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

check_command() {
    local cmd="$1"
    if ! command -v "${cmd}" &>/dev/null; then
        error_exit "Required command '${cmd}' not found. Please install it first."
    fi
}

# ------------------------------------------------------------------------------
# Pre-Flight Checks
# ------------------------------------------------------------------------------
log "Starting bootstrap script."

# 1) Verify required environment variables for Terraform
: "${DO_TOKEN:?Environment variable DO_TOKEN must be set.}"
: "${CLOUDFLARE_EMAIL:?Environment variable CLOUDFLARE_EMAIL must be set.}"
: "${CLOUDFLARE_API_TOKEN:?Environment variable CLOUDFLARE_API_TOKEN must be set.}"
: "${CLOUDFLARE_ZONE:?Environment variable CLOUDFLARE_ZONE must be set.}"
: "${INITIAL_PASSWORD_HASH:?Environment variable INITIAL_PASSWORD_HASH must be set.}"

# 2) Verify essential executables
for cmd in git terraform ansible-playbook; do
    check_command "${cmd}"
done

# 3) Verify SSH key exists
if [[ ! -f "${SSH_KEY_PATH}" ]]; then
    error_exit "SSH key not found at ${SSH_KEY_PATH}. Ensure this path is correct."
fi

# 4) Validate REPO_URL
if [[ -z "${REPO_URL}" ]]; then
    error_exit "GITHUB_REPO_URL is not set. Please export it or set it before running."
fi

# ------------------------------------------------------------------------------
# Step 1: Clone or Update the GitHub Repository
# ------------------------------------------------------------------------------
log "Cloning or updating Git repository from ${REPO_URL} into ${TARGET_DIR}."
mkdir -p "$(dirname "${TARGET_DIR}")"
if [[ -d "${TARGET_DIR}/.git" ]]; then
    log "Repository already exists. Pulling latest changes."
    git -C "${TARGET_DIR}" pull --ff-only 2>&1 | tee -a "${LOG_FILE}" || \
        error_exit "Failed to pull latest changes in ${TARGET_DIR}."
else
    log "Cloning repository."
    git clone "${REPO_URL}" "${TARGET_DIR}" 2>&1 | tee -a "${LOG_FILE}" || \
        error_exit "Failed to clone repository from ${REPO_URL}."
fi

# Derive directories
REPO_NAME="$(basename -s .git "${REPO_URL}")"
CLONE_DIR="${TARGET_DIR}"
TF_DIR="${CLONE_DIR}/terraform/environments/${TF_ENV}"
ANSIBLE_DIR="${CLONE_DIR}/ansible"
INV_DIR="${ANSIBLE_DIR}/inventories/${TF_ENV}"
INV_FILE="${INV_DIR}/hosts.ini"
TFVARS_FILE="${TF_DIR}/terraform.tfvars"

# ------------------------------------------------------------------------------
# Step 2: Prepare Terraform Variables File
# ------------------------------------------------------------------------------
log "Ensuring Terraform .tfvars exists at ${TFVARS_FILE}."
if [[ ! -f "${TFVARS_FILE}" ]]; then
    cat > "${TFVARS_FILE}" <<EOF
do_token = "${DO_TOKEN}"
cloudflare_email = "${CLOUDFLARE_EMAIL}"
cloudflare_api_token = "${CLOUDFLARE_API_TOKEN}"
cloudflare_zone = "${CLOUDFLARE_ZONE}"
ssh_key_path = "${SSH_KEY_PATH}"
initial_password_hash = "${INITIAL_PASSWORD_HASH}"
EOF
    log "Created ${TFVARS_FILE} with necessary variables."
else
    log "Terraform .tfvars already exists; skipping creation."
fi

# ------------------------------------------------------------------------------
# Step 3: Run Terraform to Provision Infrastructure
# ------------------------------------------------------------------------------
log "Running Terraform in ${TF_DIR}."
pushd "${TF_DIR}" > /dev/null

log "Initializing Terraform..."
terraform init -input=false 2>&1 | tee -a "${LOG_FILE}" || error_exit "Terraform init failed."

log "Applying Terraform (auto-approve)..."
terraform apply -input=false -auto-approve 2>&1 | tee -a "${LOG_FILE}" || \
    error_exit "Terraform apply failed."

# Extract the Vault droplet IP
VAULT_IP="$(terraform output -raw vault_ip)"
log "Terraform provisioned VM with IP: ${VAULT_IP}"

popd > /dev/null

# ------------------------------------------------------------------------------
# Step 4: Generate Ansible Inventory from Terraform Output
# ------------------------------------------------------------------------------
log "Generating Ansible inventory."

mkdir -p "${INV_DIR}"
cat > "${INV_FILE}" <<EOF
[vault]
${VAULT_IP} ansible_user=cbwinslow ansible_ssh_private_key_file=${HOME}/.ssh/id_ed25519

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

log "Ansible inventory written to ${INV_FILE}."

# ------------------------------------------------------------------------------
# Step 5: Run Ansible Playbook to Configure the VM
# ------------------------------------------------------------------------------
log "Running Ansible playbook (site.yml)."
pushd "${ANSIBLE_DIR}" > /dev/null

ansible-playbook -i "${INV_FILE}" site.yml 2>&1 | tee -a "${LOG_FILE}" || \
    error_exit "Ansible playbook failed."

popd > /dev/null

# ------------------------------------------------------------------------------
# Final Steps & Summary
# ------------------------------------------------------------------------------
cat <<SUMMARY | tee -a "${LOG_FILE}"

===============================================
Bootstrap Complete!
===============================================
• GitHub repo: ${REPO_URL} cloned into: ${CLONE_DIR}
• Terraform environment: ${TF_DIR}
  – VM public IP: ${VAULT_IP}
  – DNS: vault.${CLOUDFLARE_ZONE} → ${VAULT_IP}
• Ansible inventory: ${INV_FILE}
• Ansible playbook: ${ANSIBLE_DIR}/site.yml executed successfully.

Next Steps:
  1. SSH into the new VM:
       ssh cbwinslow@${VAULT_IP}

  2. Verify Docker and NVIDIA (if applicable):
       docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

  3. Access services:
       • Vault (dev mode): http://${VAULT_IP}:8200/
       • code-server:  http://${VAULT_IP}:8080/
       • Ensure UFW is running:
           sudo ufw status

  4. Customize or extend:
       • Add more Terraform modules under terraform/modules.
       • Add more Ansible roles under ansible/roles.
       • Integrate CI/CD by running this script in a pipeline.

Thanks for using the bootstrap script! Happy coding, CBW! 😎
===============================================
SUMMARY

exit 0
