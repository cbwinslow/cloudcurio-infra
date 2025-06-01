################################################################################
# Dockerfile: “dev” container – Python, Node, LangChain, OpenAI-SDK, etc.
# Base: Ubuntu 22.04
################################################################################

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ARG NB_USER=devuser
ARG NB_UID=1000
ARG NB_GID=1000

# 1) Install system dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       sudo \
       gnupg2 \
       curl \
       git \
       build-essential \
       python3.11 \
       python3.11-venv \
       python3-pip \
       nodejs \
       npm \
       redis-tools \
       jq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# 2) Create non-root user for development
RUN groupadd --gid ${NB_GID} ${NB_USER} \
  && useradd --uid ${NB_UID} --gid ${NB_GID} -m ${NB_USER} \
  && echo "${NB_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${NB_USER}
WORKDIR /workspace

# 3) Upgrade pip, install Python packages
RUN python3.11 -m pip install --upgrade pip wheel \
  && pip install --no-cache-dir \
       fastapi[all] \
       uvicorn[standard] \
       flask \
       django \
       pydantic \
       langchain \
       openai \
       openllm \
       torch \
       numpy \
       pandas \
       comfyui \
       'stable-diffusion-webui' \
       anythingllm \
       gpt4all \
       ollama \
       crewai \
       langsmith \
       langraph \
       camel-multiagent

# 4) Install Node.js AI SDKs and Replit/Vercel/clis
RUN npm install -g \
       apify \
       coolify-cli \
       dify-cli \
       vercel \
       @langchain/langchain \
       @openai/sdk \
       @something-ai-sdk \
       node-gpt4all

# 5) Install Podman (rootless) if you really want—requires some kernel features
#    Note: you might prefer Podman on the host/VM instead of in-container
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       podman \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER ${NB_USER}

# 6) Expose typical dev ports
EXPOSE 8000 3000 7860 5000   # 7860 for StableDiffusion-webui, 5000 for ComfyUI

# 7) Default entrypoint: drop to bash
ENTRYPOINT [ "/bin/bash" ]
