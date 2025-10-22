#!/usr/bin/env bash
###############################################################################
# Script Name:   setup_fullstack_dev_env.sh
# Date:          2025-06-01
# Author:        ChatGPT (for Blaine “CBW” Winslow)
#
# Summary:
#   This script bootstraps a Dockerfile and a docker-compose.yml for a
#   self-contained full-stack development environment. The Docker image
#   includes Python 3, pip, virtualenv, Node.js/TypeScript, Git, curl,
#   PostgreSQL client tools, and installs a handful of common Python packages
#   (FastAPI, Flask, Django, Pydantic, LangChain, OpenLLM, PyTorch, NumPy,
#   Pandas). Once built, you can run a container that mounts your local
#   project directory for interactive development.
#
# Inputs:
#   - None explicitly (script creates a “dev_env” subdirectory).
#
# Outputs:
#   - dev_env/Dockerfile
#   - dev_env/docker-compose.yml
#   - Built Docker image named “cbw/fullstack-dev:latest”
#
# Parameters:
#   SCRIPT_DIR      – Directory where this script is located.
#   DEV_DIR         – Path to the generated “dev_env” directory.
#   IMAGE_NAME      – Name:tag for the Docker image.
#
# Modification Log:
#   2025-06-01  CBW    Created initial version with full-stack tooling.
#
###############################################################################

set -euo pipefail
IFS=$'\n\t'

# ------------------------------------------------------------------------------
# Variables and Configuration
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DEV_DIR="${SCRIPT_DIR}/dev_env"
IMAGE_NAME="cbw/fullstack-dev:latest"
LOG_FILE="${DEV_DIR}/build.log"

# ------------------------------------------------------------------------------
# Logging Functions
# ------------------------------------------------------------------------------

log() {
    # Prints a timestamped message to stdout and appends to log file.
    local ts
    ts="$(date +"%Y-%m-%d %H:%M:%S")"
    echo "[$ts] $*" | tee -a "${LOG_FILE}"
}

error_exit() {
    # Called on any error: prints message and exits.
    echo "ERROR: $*" | tee -a "${LOG_FILE}" >&2
    exit 1
}

# ------------------------------------------------------------------------------
# Pre-flight Checks
# ------------------------------------------------------------------------------

# Ensure Docker is installed and runnable
if ! command -v docker &>/dev/null; then
    error_exit "Docker is not installed or not in PATH. Please install Docker first."
fi

# Ensure docker-compose is installed
if ! command -v docker-compose &>/dev/null; then
    error_exit "docker-compose is not installed or not in PATH. Please install docker-compose first."
fi

# Create or clean the dev_env directory
if [ -d "${DEV_DIR}" ]; then
    log "Cleaning existing '${DEV_DIR}' directory..."
    rm -rf "${DEV_DIR}"
fi
mkdir -p "${DEV_DIR}"

# Initialize (or truncate) log file
: > "${LOG_FILE}"
log "Starting full-stack dev environment setup."

# ------------------------------------------------------------------------------
# Generate Dockerfile
# ------------------------------------------------------------------------------

log "Generating Dockerfile at '${DEV_DIR}/Dockerfile'..."
cat > "${DEV_DIR}/Dockerfile" <<'EOF'
################################################################################
# Dockerfile: Full-Stack Development Environment
# Base: Ubuntu 22.04 LTS
#
# Contains:
#   - Python 3.11, pip, virtualenv
#   - Node.js 18.x, npm
#   - Git, curl, build tools
#   - PostgreSQL client
#   - Common Python packages for web/ML/AI: FastAPI, Flask, Django, Pydantic,
#     LangChain, OpenLLM, PyTorch, NumPy, Pandas
#
# Usage:
#   docker build -t cbw/fullstack-dev:latest .
#   docker run --rm -it -v <your-project>:/workspace -p 8000:8000 cbw/fullstack-dev
#
################################################################################

# 1) Use Ubuntu 22.04 as base image (LTS, stable)
FROM ubuntu:22.04

# 2) Avoid interactive prompts during APT
ENV DEBIAN_FRONTEND=noninteractive

# 3) Update & install core dependencies in one layer, then clean up APT caches
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.11 \
        python3.11-venv \
        python3-pip \
        python3-setuptools \
        nodejs \
        npm \
        git \
        curl \
        build-essential \
        ca-certificates \
        libffi-dev \
        libssl-dev \
        libpq-dev \
        postgresql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 4) Upgrade pip and install Python packages
RUN python3.11 -m pip install --upgrade pip wheel && \
    pip install --no-cache-dir \
        fastapi[all] \
        uvicorn[standard] \
        flask \
        django \
        pydantic \
        langchain \
        openllm \
        torch \
        numpy \
        pandas

# 5) Create a non-root user 'devuser' with sudo (if needed)
RUN useradd -m -s /bin/bash devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 6) Set working directory and default user
WORKDIR /workspace
USER devuser

# 7) Expose a default port (e.g., for FastAPI UVicorn)
EXPOSE 8000

# 8) Default entrypoint: drop into bash for interactive dev
ENTRYPOINT ["/bin/bash"]
EOF

log "Dockerfile generated."

# ------------------------------------------------------------------------------
# Generate docker-compose.yml
# ------------------------------------------------------------------------------

log "Generating docker-compose.yml at '${DEV_DIR}/docker-compose.yml'..."
cat > "${DEV_DIR}/docker-compose.yml" <<'EOF'
version: "3.9"

services:
  dev:
    image: cbw/fullstack-dev:latest
    build:
      context: .
      dockerfile: Dockerfile
    container_name: cbw_fullstack_dev
    stdin_open: true
    tty: true
    volumes:
      - ./workspace:/workspace     # Mount host ./workspace as /workspace in container
    ports:
      - "8000:8000"                # Map FastAPI/Flask default port
      - "3000:3000"                # Map a default React/Vue/Node port (if needed)
    environment:
      - PYTHONUNBUFFERED=1         # Unbuffered Python output
      - NODE_ENV=development       # Node.js environment
    networks:
      - dev_net

networks:
  dev_net:
    driver: bridge
EOF

log "docker-compose.yml generated."

# ------------------------------------------------------------------------------
# Create a placeholder workspace directory
# ------------------------------------------------------------------------------

log "Creating 'workspace' directory for your code..."
mkdir -p "${DEV_DIR}/workspace"
log "You can now place your front-end/back-end code under 'dev_env/workspace'."

# ------------------------------------------------------------------------------
# Build the Docker image
# ------------------------------------------------------------------------------

log "Building Docker image '${IMAGE_NAME}' (this may take several minutes)..."
(
  cd "${DEV_DIR}"
  docker-compose build 2>&1 | tee -a "${LOG_FILE}" || error_exit "docker-compose build failed."
)
log "Docker image '${IMAGE_NAME}' built successfully."

# ------------------------------------------------------------------------------
# Reminders / Next Steps
# ------------------------------------------------------------------------------

cat <<'MSG'

Setup complete! 

To start your full-stack dev container, run:

    cd "${DEV_DIR}"
    docker-compose up -d

This will:
  • Launch a container named "cbw_fullstack_dev".
  • Mount the local "workspace/" folder into "/workspace" inside the container.
  • Expose port 8000 (for Python/FastAPI/Flask/Django) and port 3000 (for Node/React/etc.).

Enter the container’s shell:

    docker-compose exec dev /bin/bash

Inside the container, you will have:
  - Python 3.11 and pip (with FastAPI, Flask, Django, etc.)
  - Node.js 18.x and npm (TypeScript-ready)
  - git, curl, build-essential, PostgreSQL client tools
  - A non-root user "devuser" (you) in /workspace
  - A clean Ubuntu environment oriented to “full-stack” workflows

Happy coding! 

MSG

# ------------------------------------------------------------------------------
# End of script
# ------------------------------------------------------------------------------
