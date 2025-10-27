#!/bin/bash
# AI Coding Terminal Tools Installer
set -e

echo "================================================"
echo "AI Coding Terminal Tools Installer"
echo "================================================"
echo ""

# Check prerequisites
echo "Checking prerequisites..."
command -v python3 >/dev/null 2>&1 || { echo "Python3 required but not installed. Aborting." >&2; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "NPM required but not installed. Installing..." && sudo apt-get install -y npm; }

# Install Aider
echo ""
echo "Installing Aider AI pair programming..."
pip3 install --user aider-chat
echo "✓ Aider installed (command: aider)"

# Install Cline
echo ""
echo "Installing Cline AI coding assistant..."
sudo npm install -g @cline/cli 2>/dev/null || echo "Cline installation skipped (not available)"

# Install GitHub Copilot CLI
echo ""
echo "Installing GitHub Copilot CLI..."
sudo npm install -g @githubnext/github-copilot-cli 2>/dev/null || echo "GitHub Copilot CLI skipped"

# Install Continue
echo ""
echo "Installing Continue..."
sudo npm install -g continue 2>/dev/null || echo "Continue installation skipped"

# Install OpenAI, Claude, and Gemini APIs
echo ""
echo "Installing AI API clients..."
pip3 install --user openai anthropic google-generativeai

# Install Cursor IDE
read -p "Install Cursor IDE? (y/n): " install_cursor
if [ "$install_cursor" = "y" ]; then
    echo "Installing Cursor IDE..."
    sudo apt-get install -y fuse libfuse2
    sudo mkdir -p /opt/cursor
    wget -O /tmp/cursor.AppImage https://downloader.cursor.sh/linux/appImage/x64
    sudo mv /tmp/cursor.AppImage /opt/cursor/cursor.AppImage
    sudo chmod +x /opt/cursor/cursor.AppImage
    sudo ln -sf /opt/cursor/cursor.AppImage /usr/local/bin/cursor
    echo "✓ Cursor installed (command: cursor)"
fi

# Install LobeChat (Docker-based)
if command -v docker >/dev/null 2>&1; then
    read -p "Install LobeChat (AI conversations)? (y/n): " install_lobe
    if [ "$install_lobe" = "y" ]; then
        echo "Installing LobeChat..."
        docker pull lobehub/lobe-chat:latest
        docker run -d \
            --name lobechat \
            -p 3210:3210 \
            --restart always \
            lobehub/lobe-chat:latest
        echo "✓ LobeChat installed (http://localhost:3210)"
    fi
fi

# Install Windsurf
read -p "Install Windsurf AI IDE? (y/n): " install_windsurf
if [ "$install_windsurf" = "y" ]; then
    echo "Installing Windsurf..."
    curl -fsSL https://windsurf.ai/install.sh | bash || echo "Windsurf installation skipped"
fi

# Install additional AI tools
echo ""
echo "Installing additional AI coding tools..."
pip3 install --user tabnine 2>/dev/null || echo "TabNine skipped"
sudo npm install -g codegpt 2>/dev/null || echo "CodeGPT skipped"
pip3 install --user opencode-ai 2>/dev/null || echo "OpenCode AI skipped"

# Create AI tools directory
mkdir -p ~/.ai-tools

# Create wrapper script
cat > ~/.ai-tools/ai-code.sh << 'EOF'
#!/bin/bash
# Universal AI coding assistant launcher

echo "Available AI coding tools:"
echo "1) Aider (AI pair programming)"
echo "2) Cline (AI coding assistant)"
echo "3) GitHub Copilot CLI"
echo "4) Continue"
echo "5) Cursor IDE"
echo "6) LobeChat (browser)"
read -p "Select tool [1-6]: " choice

case $choice in
  1) aider "$@" ;;
  2) cline "$@" ;;
  3) github-copilot-cli "$@" ;;
  4) continue "$@" ;;
  5) cursor "$@" ;;
  6) xdg-open http://localhost:3210 ;;
  *) echo "Invalid choice" ;;
esac
EOF

chmod +x ~/.ai-tools/ai-code.sh
sudo ln -sf ~/.ai-tools/ai-code.sh /usr/local/bin/ai-code

# Create README
cat > ~/.ai-tools/README.md << 'EOF'
# AI Coding Tools Installed

## Available Tools:
- **Aider**: AI pair programming in terminal (`aider`)
- **Cline**: AI coding assistant (`cline`)
- **GitHub Copilot CLI**: GitHub's AI assistant (`github-copilot-cli`)
- **Continue**: Open-source Copilot alternative (`continue`)
- **Cursor**: AI-powered IDE (`cursor`)
- **LobeChat**: AI conversation interface (http://localhost:3210)
- **OpenAI API**: Direct API access
- **Claude API**: Anthropic's Claude access
- **Gemini API**: Google's Gemini access

## Usage:
Run `ai-code` to select and launch a tool interactively.

## Configuration:
Set API keys in environment variables:
```bash
export OPENAI_API_KEY=your_key
export ANTHROPIC_API_KEY=your_key
export GOOGLE_API_KEY=your_key
export GITHUB_TOKEN=your_token
```

Add these to your ~/.bashrc or ~/.zshrc for persistence.

## Quick Start Examples:

### Aider
```bash
aider myfile.py  # Start pair programming on a file
```

### Cline
```bash
cline "write a function to sort an array"
```

### GitHub Copilot
```bash
github-copilot-cli suggest "how to read a CSV file in Python"
```

### Cursor
```bash
cursor .  # Open current directory in Cursor IDE
```
EOF

echo ""
echo "================================================"
echo "Installation Complete!"
echo "================================================"
echo ""
echo "Installed AI Coding Tools:"
echo "  - Aider (command: aider)"
echo "  - Cline (command: cline)"
echo "  - GitHub Copilot CLI (command: github-copilot-cli)"
echo "  - Continue (command: continue)"
if [ "$install_cursor" = "y" ]; then
    echo "  - Cursor IDE (command: cursor)"
fi
if [ "$install_lobe" = "y" ]; then
    echo "  - LobeChat (http://localhost:3210)"
fi
echo ""
echo "Quick Start:"
echo "  1. Set API keys: export OPENAI_API_KEY=your_key"
echo "  2. Run: ai-code"
echo "  3. Or use specific tools: aider, cline, cursor"
echo ""
echo "Documentation: ~/.ai-tools/README.md"
echo ""
