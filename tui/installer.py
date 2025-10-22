#!/usr/bin/env python3
"""
CloudCurio Infrastructure - Interactive TUI Installer

This module provides a Terminal User Interface for installing DevOps tools
using Ansible playbooks. It allows users to browse categories, select tools,
view current installation status, and manage installations interactively.

Features:
- Browse tools by category
- Multi-select tools for installation
- View installation status
- Real-time installation progress
- Error handling and recovery
- Uninstall functionality

Usage:
    python3 installer.py              # Start interactive mode
    python3 installer.py --status     # View current status
    python3 installer.py --uninstall  # Uninstall tools
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Optional

try:
    from textual.app import App, ComposeResult
    from textual.containers import Container, Horizontal, Vertical, ScrollableContainer
    from textual.widgets import Button, Checkbox, Footer, Header, Label, Static, Tree, ProgressBar, Log
    from textual.binding import Binding
    from textual.screen import ModalScreen
except ImportError:
    print("ERROR: textual package not found.")
    print("Please install it with: pip3 install textual")
    sys.exit(1)


# Tool categories and their available tools
# This maps to the Ansible roles and tags
TOOL_CATEGORIES = {
    "Programming Languages": {
        "description": "Programming languages and runtimes",
        "tools": {
            "python": {"name": "Python 3.11+", "port": None, "tag": "python"},
            "uv": {"name": "UV Package Manager", "port": None, "tag": "uv"},
            "nodejs": {"name": "Node.js 20", "port": None, "tag": "nodejs"},
            "php": {"name": "PHP 8+", "port": None, "tag": "php"},
        }
    },
    "Containers": {
        "description": "Container runtimes and orchestration",
        "tools": {
            "docker": {"name": "Docker Engine", "port": None, "tag": "docker"},
            "docker-compose": {"name": "Docker Compose", "port": None, "tag": "docker-compose"},
            "podman": {"name": "Podman", "port": None, "tag": "podman"},
        }
    },
    "Databases": {
        "description": "Database systems",
        "tools": {
            "postgresql": {"name": "PostgreSQL 15", "port": 5432, "tag": "postgresql"},
            "mysql": {"name": "MySQL 8.0", "port": 3306, "tag": "mysql"},
            "clickhouse": {"name": "ClickHouse", "port": 8123, "tag": "clickhouse"},
            "influxdb": {"name": "InfluxDB 2.x", "port": 8086, "tag": "influxdb"},
            "timescaledb": {"name": "TimescaleDB", "port": 5432, "tag": "timescaledb"},
            "victoriametrics": {"name": "VictoriaMetrics", "port": 8428, "tag": "victoriametrics"},
        }
    },
    "Web Servers": {
        "description": "Web servers and reverse proxies",
        "tools": {
            "apache2": {"name": "Apache2", "port": 80, "tag": "apache2"},
            "caddy": {"name": "Caddy", "port": 80, "tag": "caddy"},
            "traefik": {"name": "Traefik", "port": 80, "tag": "traefik"},
        }
    },
    "AI/ML Tools": {
        "description": "Artificial Intelligence and Machine Learning",
        "tools": {
            "ollama": {"name": "Ollama", "port": 11434, "tag": "ollama"},
            "localai": {"name": "LocalAI", "port": 8080, "tag": "localai"},
            "openwebui": {"name": "Open WebUI", "port": 3000, "tag": "openwebui"},
            "flowise": {"name": "Flowise", "port": 3001, "tag": "flowise"},
            "haystack": {"name": "Haystack", "port": None, "tag": "haystack"},
        }
    },
    "Monitoring": {
        "description": "Monitoring and observability tools",
        "tools": {
            "grafana": {"name": "Grafana", "port": 3002, "tag": "grafana"},
            "prometheus": {"name": "Prometheus", "port": 9090, "tag": "prometheus"},
            "loki": {"name": "Loki", "port": 3100, "tag": "loki"},
            "elasticsearch": {"name": "Elasticsearch", "port": 9200, "tag": "elasticsearch"},
            "opensearch": {"name": "OpenSearch", "port": 9200, "tag": "opensearch"},
            "graylog": {"name": "Graylog", "port": 9000, "tag": "graylog"},
            "graphite": {"name": "Graphite", "port": 8085, "tag": "graphite"},
        }
    },
    "Infrastructure": {
        "description": "Infrastructure as Code tools",
        "tools": {
            "terraform": {"name": "Terraform", "port": None, "tag": "terraform"},
            "pulumi": {"name": "Pulumi", "port": None, "tag": "pulumi"},
            "consul": {"name": "Consul", "port": 8500, "tag": "consul"},
            "kong": {"name": "Kong", "port": 8000, "tag": "kong"},
        }
    },
    "Security": {
        "description": "Authentication and security tools",
        "tools": {
            "keycloak": {"name": "Keycloak", "port": 8080, "tag": "keycloak"},
            "bitwarden": {"name": "Bitwarden", "port": 8200, "tag": "bitwarden"},
        }
    },
    "Development": {
        "description": "Development environments and IDEs",
        "tools": {
            "vscode": {"name": "VS Code", "port": None, "tag": "vscode"},
            "cursor": {"name": "Cursor", "port": None, "tag": "cursor"},
            "zed": {"name": "Zed", "port": None, "tag": "zed"},
            "vscode-server": {"name": "VS Code Server", "port": 8080, "tag": "vscode-server"},
        }
    },
    "Networking": {
        "description": "VPN and networking tools",
        "tools": {
            "tailscale": {"name": "Tailscale", "port": None, "tag": "tailscale"},
            "zerotier": {"name": "ZeroTier", "port": None, "tag": "zerotier"},
            "wireguard": {"name": "WireGuard", "port": 51820, "tag": "wireguard"},
            "cloudflared": {"name": "Cloudflared", "port": None, "tag": "cloudflared"},
        }
    },
}


class InstallationStatusScreen(ModalScreen):
    """Modal screen showing installation status."""
    
    BINDINGS = [
        Binding("escape", "dismiss", "Close"),
    ]

    def __init__(self, selected_tools: List[str]) -> None:
        super().__init__()
        self.selected_tools = selected_tools
        
    def compose(self) -> ComposeResult:
        with Container(id="status-container"):
            yield Header()
            yield Label(f"Installing {len(self.selected_tools)} tool(s)...", id="status-title")
            yield ProgressBar(total=len(self.selected_tools), show_eta=True, id="progress")
            yield Log(id="install-log")
            yield Button("Close", variant="primary", id="close-btn")


class CloudCurioInstaller(App):
    """Interactive TUI for CloudCurio Infrastructure installation."""
    
    CSS = """
    #main-container {
        layout: grid;
        grid-size: 2 1;
        grid-columns: 1fr 2fr;
    }
    
    #category-tree {
        border: solid green;
        height: 100%;
    }
    
    #tool-panel {
        border: solid blue;
        height: 100%;
        overflow-y: auto;
    }
    
    #status-container {
        align: center middle;
        background: $surface;
        border: solid $primary;
        width: 80%;
        height: auto;
        padding: 2;
    }
    
    .tool-checkbox {
        margin: 1;
    }
    
    #button-bar {
        dock: bottom;
        height: 3;
        background: $panel;
    }
    """
    
    BINDINGS = [
        Binding("q", "quit", "Quit"),
        Binding("i", "install", "Install"),
        Binding("s", "status", "Status"),
        Binding("r", "refresh", "Refresh"),
    ]
    
    def __init__(self):
        super().__init__()
        self.selected_tools: List[str] = []
        self.current_category = None
        
    def compose(self) -> ComposeResult:
        """Create the UI layout."""
        yield Header()
        
        with Container(id="main-container"):
            # Left panel: Category tree
            with Vertical(id="category-tree"):
                yield Label("📦 Tool Categories", id="category-label")
                tree = Tree("Categories")
                tree.root.expand()
                
                for category, data in TOOL_CATEGORIES.items():
                    node = tree.root.add(f"📁 {category}")
                    node.data = category
                    
                yield tree
            
            # Right panel: Tools in selected category
            with ScrollableContainer(id="tool-panel"):
                yield Label("Select tools to install", id="tool-label")
        
        # Bottom button bar
        with Horizontal(id="button-bar"):
            yield Button("Install Selected", variant="success", id="install-btn")
            yield Button("View Status", variant="primary", id="status-btn")
            yield Button("Refresh", variant="warning", id="refresh-btn")
            yield Button("Quit", variant="error", id="quit-btn")
        
        yield Footer()
    
    def on_mount(self) -> None:
        """Called when the app is mounted."""
        self.title = "CloudCurio Infrastructure Installer"
        self.sub_title = "Interactive DevOps Tools Installation"
    
    def on_tree_node_selected(self, event: Tree.NodeSelected) -> None:
        """Handle category selection."""
        if event.node.data:
            self.current_category = event.node.data
            self.update_tool_panel()
    
    def update_tool_panel(self) -> None:
        """Update the tool panel with tools from selected category."""
        if not self.current_category:
            return
        
        panel = self.query_one("#tool-panel", ScrollableContainer)
        panel.remove_children()
        
        category_data = TOOL_CATEGORIES.get(self.current_category, {})
        
        # Add category description
        panel.mount(Label(f"Category: {self.current_category}"))
        panel.mount(Label(f"Description: {category_data.get('description', '')}"))
        panel.mount(Label(""))
        
        # Add checkboxes for each tool
        tools = category_data.get("tools", {})
        for tool_id, tool_info in tools.items():
            port_info = f" (Port: {tool_info['port']})" if tool_info['port'] else ""
            checkbox = Checkbox(
                f"{tool_info['name']}{port_info}",
                id=f"check-{tool_id}",
                classes="tool-checkbox"
            )
            checkbox.data = tool_info['tag']
            panel.mount(checkbox)
    
    def on_checkbox_changed(self, event: Checkbox.Changed) -> None:
        """Handle checkbox state changes."""
        tool_tag = event.checkbox.data
        
        if event.value:
            if tool_tag not in self.selected_tools:
                self.selected_tools.append(tool_tag)
        else:
            if tool_tag in self.selected_tools:
                self.selected_tools.remove(tool_tag)
    
    def on_button_pressed(self, event: Button.Pressed) -> None:
        """Handle button presses."""
        if event.button.id == "install-btn":
            self.action_install()
        elif event.button.id == "status-btn":
            self.action_status()
        elif event.button.id == "refresh-btn":
            self.action_refresh()
        elif event.button.id == "quit-btn":
            self.action_quit()
    
    def action_install(self) -> None:
        """Install selected tools."""
        if not self.selected_tools:
            self.notify("No tools selected for installation", severity="warning")
            return
        
        # Show installation screen
        self.push_screen(InstallationStatusScreen(self.selected_tools))
        
        # Run ansible playbook
        try:
            tags = ",".join(self.selected_tools)
            cmd = [
                "ansible-playbook",
                "-i", "inventory/hosts.ini",
                "sites.yml",
                "--tags", tags
            ]
            
            self.notify(f"Installing {len(self.selected_tools)} tool(s)...", severity="information")
            
            # TODO: Run in background and update progress
            # For now, just show the command that would be run
            self.notify(f"Command: {' '.join(cmd)}", severity="information")
            
        except Exception as e:
            self.notify(f"Installation error: {str(e)}", severity="error")
    
    def action_status(self) -> None:
        """Show installation status."""
        # TODO: Implement status checking
        self.notify("Status checking not yet implemented", severity="information")
    
    def action_refresh(self) -> None:
        """Refresh the tool list."""
        self.update_tool_panel()
        self.notify("Tool list refreshed", severity="information")
    
    def action_quit(self) -> None:
        """Quit the application."""
        self.exit()


def check_status() -> None:
    """Check and display installation status."""
    print("Checking installation status...")
    print("\nNOTE: Status checking functionality will be implemented in the next iteration.")
    print("For now, you can manually check installations with:")
    print("  - docker --version")
    print("  - python3 --version")
    print("  - ansible --version")
    print("  etc.")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="CloudCurio Infrastructure - Interactive Installer"
    )
    parser.add_argument(
        "--status",
        action="store_true",
        help="View current installation status"
    )
    parser.add_argument(
        "--uninstall",
        action="store_true",
        help="Uninstall tools"
    )
    
    args = parser.parse_args()
    
    if args.status:
        check_status()
        return
    
    if args.uninstall:
        print("Uninstall functionality will be implemented in the next iteration.")
        return
    
    # Run the TUI
    app = CloudCurioInstaller()
    app.run()


if __name__ == "__main__":
    main()
