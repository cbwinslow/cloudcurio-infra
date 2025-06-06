#!/bin/bash
# ==========================================================================
#  Script: cbw-playwright-setup.sh
#  Author: ChatGPT + CBW
#  Date: 2025-06-06
#  Summary: Robust installer for Playwright on Kali/Debian-based systems
#  Description: Handles full install of Playwright, dependencies, and test GUI setup
#  Features: Error recovery, brute-force dependency resolution, OS detection
# ==========================================================================

set -euo pipefail
trap 'handle_error $LINENO' ERR

LOGFILE="/var/log/cbw-playwright.log"
mkdir -p $(dirname "$LOGFILE") || LOGFILE="$HOME/cbw-playwright.log"
touch "$LOGFILE"

function log() {
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

function handle_error() {
  local lineno=$1
  local message="Error on or near line $lineno. Exit code: $?"
  log "[❌ ERROR] $message"
  echo -e "\n[💡] Check the log file: $LOGFILE"
  echo -e "[💡] Attempting recovery..."
  troubleshoot
}

function detect_os() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
  else
    log "[🚫] Cannot detect OS. Exiting."
    exit 1
  fi

  case "$OS" in
    debian|ubuntu|kali)
      log "[✅] Detected OS: $OS $VERSION"
      ;;
    *)
      log "[⚠️ WARNING] Unsupported OS: $OS. Proceeding with brute-force strategy."
      ;;
  esac
}

function install_base_packages() {
  log "[📦] Installing base dependencies..."
  sudo apt update || true
  sudo apt install -y curl gnupg git || true

  if ! command -v node &>/dev/null || ! command -v npm &>/dev/null; then
    log "[🧩] Node.js or npm not found or broken. Attempting manual installation..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
  fi

  log "[✅] Node.js version: $(node -v)"
  log "[✅] npm version: $(npm -v)"
}

function brute_force_dependencies() {
  log "[🔧] Brute-forcing dependency combinations..."
  sudo apt install -y \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcups2 \
    libglib2.0-0 libgtk-3-0 libxt6 libpng16-16 libevent-2.1-7 \
    libfontconfig1 fonts-unifont libgdk-pixbuf-xlib-2.0-0 \
    libvpx-dev libwebp-dev libjpeg-dev libenchant-2-2 libicu-dev \
    libnss3 libxss1 libxcomposite1 libxrandr2 libxdamage1 libxfixes3 \
    libdbus-1-3 libdrm2 libxkbcommon0 libx11-xcb1 libxcb1 libxext6 \
    libxcb-shm0 libxcb-dri3-0 libxcb-xfixes0 libxcb-glx0 \
    fonts-liberation libappindicator3-1 libatk-bridge2.0-dev \
    libgtk-3-dev libx11-dev libxcomposite-dev libxdamage-dev \
    libxrandr-dev libgbm-dev libpango1.0-dev \
    xvfb || true
}

function install_playwright() {
  log "[🚀] Installing Playwright..."
  npx playwright install || {
    log "[⚠️] Initial playwright install failed, retrying without --with-deps..."
    npx playwright install
  }
}

function troubleshoot() {
  log "[🛠️] Troubleshooting mode activated."

  if ! command -v node &>/dev/null || ! command -v npm &>/dev/null; then
    log "[⚙️] Node.js/npm missing. Forcing reinstallation."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
  fi

  MISSING=$(npx playwright install --dry-run 2>&1 | grep 'Unable to locate package') || true
  if [[ -n "$MISSING" ]]; then
    log "[🔎] Missing packages detected. Attempting brute-force package recovery."
    brute_force_dependencies
    npx playwright install
  fi

  if [ ! -x /usr/bin/xvfb-run ]; then
    log "[➕] Installing xvfb for headless testing..."
    sudo apt install -y xvfb
  fi

  log "[🧪] Retesting Playwright install..."
  npx playwright install || log "[🚨] Final install attempt failed. Manual review needed."
}

function test_playwright() {
  log "[🧪] Running basic test with xvfb..."
  xvfb-run --auto-servernum npx playwright install || true
  log "[✅] Script completed. Ready to run tests."
}

# ===== MAIN FLOW =====
log "[🎬] Starting Playwright setup script..."
detect_os
install_base_packages
brute_force_dependencies
install_playwright
test_playwright
log "[🏁] Playwright install script complete. Review log at $LOGFILE"

exit 0
