#!/usr/bin/env bash
set -euo pipefail

# (– SECTION A – Check for root)
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit 1
fi

# (– SECTION B – Add HashiCorp’s GPG and repo, then install Vault)
apt-get update -y
apt-get install -y --no-install-recommends \
    gnupg2 \
    software-properties-common \
    curl

# Add HashiCorp’s official GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add the official HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  > /etc/apt/sources.list.d/hashicorp.list

# Install Vault 
apt-get update -y
apt-get install -y --no-install-recommends vault

# (– SECTION C – Enable & start Vault in “dev” or “server” mode)
# For a production server, you'd create a systemd unit or configure Vault’s storage/backend.
# Here’s a minimal “dev mode” example; adjust for a real cluster later:
cat > /etc/systemd/system/vault.service << 'EOF'
[Unit]
Description=Vault Server (dev mode)
After=network.target

[Service]
ExecStart=/usr/bin/vault server -dev -dev-listen-address=0.0.0.0:8200
User=root
Group=root
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable vault.service
systemctl start vault.service

echo "Vault installation complete. Vault is running in dev mode on port 8200."
