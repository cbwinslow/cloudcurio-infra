#!/usr/bin/env python3
# ================================================================
# Script Name : bwsecrets.py
# Date        : 2025-06-03
# Author      : Blaine Winslow (CBW) & ChatGPT
# Summary     : CLI tool to fetch and inject secrets using Bitwarden CLI
# Dependencies: bitwarden-cli, python-dotenv, typer, rich
# ================================================================

import os
import subprocess
import typer
from dotenv import load_dotenv, set_key
from rich.console import Console
from pathlib import Path

app = typer.Typer()
console = Console()

# Path to .env file for storing injected secrets
SECRETS_DIR = Path("secrets")
SECRETS_DIR.mkdir(exist_ok=True)
DEFAULT_ENV_FILE = SECRETS_DIR / "default.env"


@app.command()
def login(email: str = typer.Option(..., help="Your Bitwarden email")):
    """Login to Bitwarden and store session token"""
    console.print(f"[bold green]Logging in as {email}...[/bold green]")
    subprocess.run(["bw", "login", email], check=True)
    result = subprocess.run(["bw", "unlock", "--raw"], capture_output=True, text=True, check=True)
    session_token = result.stdout.strip()
    os.environ["BW_SESSION"] = session_token
    console.print("[bold green]Unlocked and session stored in environment.[/bold green]")


@app.command()
def fetch(secret_name: str = typer.Argument(...), env_file: Path = typer.Option(DEFAULT_ENV_FILE)):
    """Fetch a Bitwarden secret and inject it into an .env file"""
    session = os.environ.get("BW_SESSION")
    if not session:
        console.print("[red]No Bitwarden session found. Run `bwsecrets login` first.[/red]")
        raise typer.Exit(code=1)

    result = subprocess.run(["bw", "get", "password", secret_name], capture_output=True, text=True, env={"BW_SESSION": session})
    if result.returncode != 0:
        console.print(f"[red]Failed to fetch secret: {result.stderr}[/red]")
        raise typer.Exit(code=1)

    secret_value = result.stdout.strip()
    env_file = Path(env_file)
    env_file.touch(exist_ok=True)
    load_dotenv(dotenv_path=env_file)
    set_key(env_file, secret_name.upper(), secret_value)
    console.print(f"[cyan]Secret '{secret_name}' injected into {env_file}.[/cyan]")


@app.command()
def inject_all(env_file: Path = typer.Option(DEFAULT_ENV_FILE)):
    """Export all variables from the .env file into environment"""
    if not env_file.exists():
        console.print(f"[red]{env_file} not found. Fetch some secrets first.[/red]")
        raise typer.Exit(code=1)

    load_dotenv(dotenv_path=env_file, override=True)
    console.print(f"[bold yellow]Secrets from {env_file} exported to environment.[/bold yellow]")


@app.command()
def list_vault():
    """List all items in Bitwarden vault (basic info)"""
    session = os.environ.get("BW_SESSION")
    if not session:
        console.print("[red]No Bitwarden session found. Run `bwsecrets login` first.[/red]")
        raise typer.Exit(code=1)

    result = subprocess.run(["bw", "list", "items"], capture_output=True, text=True, env={"BW_SESSION": session})
    console.print(result.stdout)


@app.command()
def env_summary(env_file: Path = typer.Option(DEFAULT_ENV_FILE)):
    """Show a summary of keys in the environment file"""
    if not env_file.exists():
        console.print(f"[red]{env_file} not found.[/red]")
        raise typer.Exit(code=1)

    with open(env_file) as f:
        lines = [line.strip() for line in f if line.strip() and not line.startswith('#')]
    console.print(f"[green]{len(lines)} secrets in {env_file}[/green]")
    for line in lines:
        console.print(f" - [bold]{line.split('=')[0]}[/bold]")


if __name__ == "__main__":
    app()
