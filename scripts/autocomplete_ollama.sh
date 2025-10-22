#!/usr/bin/env bash
# Script: cbw-install-ai-autocomplete.sh
# Author: CBW + ChatGPT
# Summary: Installs Ollama, fzf, and autocomplete.sh with AI-enhanced terminal completions
# Date: 2025-06-25

set -euo pipefail
trap 'echo "[!] Error on line $LINENO"; exit 1' ERR

LOG="/tmp/CBW-ai-autocomplete.log"
BREW_BIN=$(command -v brew)

echo "[+] Logging to $LOG"
exec > >(tee -a "$LOG") 2>&1

# -------------------------
# Function: Check/Install Homebrew
# -------------------------
install_homebrew() {
  if ! command -v brew >/dev/null; then
    echo "[*] Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$($BREW_BIN shellenv)"
  fi
}

# -------------------------
# Function: Install a package if not present
# -------------------------
install_if_missing() {
  local pkg=$1
  if ! brew list "$pkg" >/dev/null 2>&1; then
    echo "[*] Installing $pkg via Homebrew..."
    brew install "$pkg"
  else
    echo "[✓] $pkg already installed"
  fi
}

# -------------------------
# Function: Install autocomplete.sh
# -------------------------
install_autocomplete_sh() {
  if ! command -v autocomplete >/dev/null 2>&1; then
    echo "[*] Installing autocomplete.sh..."
    bash <(curl -s https://autocomplete.sh/install.sh)
  else
    echo "[✓] autocomplete.sh already installed"
  fi
}

# -------------------------
# Function: Configure autocomplete to use Ollama
# -------------------------
configure_autocomplete() {
  echo "[*] Configuring autocomplete.sh to use Ollama..."
  autocomplete model set ollama || echo "[!] Could not set model"
  autocomplete config set ollama_model mistral || echo "[!] Could not set model name"
}

# -------------------------
# Function: Post-Install Validation
# -------------------------
validate_setup() {
  echo "[*] Validating install..."
  for cmd in ollama fzf autocomplete; do
    if ! command -v $cmd >/dev/null; then
      echo "[✗] $cmd failed to install."
      exit 1
    fi
  done
  echo "[✓] All components installed and validated."
}

# -------------------------
# Main Install Routine
# -------------------------
main() {
  echo "=== CBW AI AUTOCOMPLETE SETUP ==="

  install_homebrew
  install_if_missing fzf
  install_if_missing ollama
  install_autocomplete_sh
  configure_autocomplete
  validate_setup

  echo "[*] Done. You may need to reload your shell or run:"
  echo "     source ~/.bashrc  OR  source ~/.zshrc"
  echo "Try typing part of a command and pressing [TAB][TAB]!"
}

main
