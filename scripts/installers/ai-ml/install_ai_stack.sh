#!/bin/bash
# AI/ML Stack installer (AnythingLLM, LocalAI, Agent-Zero)
set -e

echo "Installing AI/ML Stack..."

# Ensure Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker first..."
    bash "$(dirname "$0")/../../container/install_docker.sh"
fi

# Create directories
sudo mkdir -p /opt/ai-stack/{anythingllm,localai,agent-zero,langfuse}

# Install AnythingLLM
echo "Installing AnythingLLM..."
docker pull mintplexlabs/anythingllm:latest
docker run -d \
    --name anythingllm \
    -p 3001:3001 \
    -v /opt/ai-stack/anythingllm:/app/server/storage \
    -e STORAGE_DIR="/app/server/storage" \
    --restart always \
    mintplexlabs/anythingllm:latest

# Install LocalAI
echo "Installing LocalAI..."
docker pull quay.io/go-skynet/local-ai:latest
docker run -d \
    --name localai \
    -p 8080:8080 \
    -v /opt/ai-stack/localai/models:/models \
    -e THREADS=$(nproc) \
    -e CONTEXT_SIZE=512 \
    --restart always \
    quay.io/go-skynet/local-ai:latest

# Install Langfuse
echo "Installing Langfuse..."
docker pull langfuse/langfuse:latest
docker run -d \
    --name langfuse \
    -p 3000:3000 \
    -v /opt/ai-stack/langfuse:/app/data \
    --restart always \
    langfuse/langfuse:latest

# Install Qdrant (vector database)
echo "Installing Qdrant vector database..."
docker pull qdrant/qdrant:latest
docker run -d \
    --name qdrant \
    -p 6333:6333 \
    -p 6334:6334 \
    -v /opt/ai-stack/qdrant:/qdrant/storage \
    --restart always \
    qdrant/qdrant:latest

echo "AI/ML Stack installed successfully!"
echo "AnythingLLM: http://localhost:3001"
echo "LocalAI: http://localhost:8080"
echo "Langfuse: http://localhost:3000"
echo "Qdrant: http://localhost:6333"
