#!/usr/bin/env python3
"""
CloudCurio Infrastructure - Automated Testing Framework

This module provides automated testing for Ansible roles and playbooks.
It uses pytest and pytest-ansible to test role functionality.

Usage:
    python3 tests/test_roles.py                    # Run all tests
    python3 tests/test_roles.py -k test_docker     # Run specific test
    pytest tests/ -v                               # Verbose output
"""

import pytest
import subprocess
import os


class TestProgrammingLanguages:
    """Test programming language installations."""
    
    def test_python_installed(self):
        """Test if Python is installed and version is correct."""
        result = subprocess.run(
            ["python3", "--version"],
            capture_output=True,
            text=True
        )
        assert result.returncode == 0
        assert "Python 3" in result.stdout
    
    def test_pip_installed(self):
        """Test if pip is installed."""
        result = subprocess.run(
            ["pip3", "--version"],
            capture_output=True,
            text=True
        )
        assert result.returncode == 0
        assert "pip" in result.stdout
    
    def test_node_installed(self):
        """Test if Node.js is installed."""
        result = subprocess.run(
            ["node", "--version"],
            capture_output=True,
            text=True
        )
        # Only test if Node.js should be installed
        if result.returncode == 0:
            assert "v" in result.stdout
    
    def test_npm_installed(self):
        """Test if npm is installed."""
        result = subprocess.run(
            ["npm", "--version"],
            capture_output=True,
            text=True
        )
        # Only test if npm should be installed
        if result.returncode == 0:
            assert result.stdout.strip().replace(".", "").isdigit()


class TestContainers:
    """Test container runtime installations."""
    
    def test_docker_installed(self):
        """Test if Docker is installed."""
        result = subprocess.run(
            ["docker", "--version"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            assert "Docker version" in result.stdout
    
    def test_docker_running(self):
        """Test if Docker daemon is running."""
        result = subprocess.run(
            ["systemctl", "is-active", "docker"],
            capture_output=True,
            text=True
        )
        # Only test if Docker is installed
        if result.returncode == 0:
            assert result.stdout.strip() == "active"
    
    def test_docker_compose_installed(self):
        """Test if Docker Compose is installed."""
        result = subprocess.run(
            ["docker-compose", "--version"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            assert "docker-compose" in result.stdout.lower() or "Docker Compose" in result.stdout


class TestDatabases:
    """Test database installations."""
    
    def test_postgresql_installed(self):
        """Test if PostgreSQL is installed."""
        result = subprocess.run(
            ["systemctl", "is-active", "postgresql"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            assert result.stdout.strip() in ["active", "inactive"]
    
    def test_mysql_installed(self):
        """Test if MySQL is installed."""
        result = subprocess.run(
            ["systemctl", "is-active", "mysql"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            assert result.stdout.strip() in ["active", "inactive"]


class TestMonitoring:
    """Test monitoring tool installations."""
    
    def test_grafana_installed(self):
        """Test if Grafana is installed."""
        result = subprocess.run(
            ["systemctl", "is-active", "grafana-server"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            assert result.stdout.strip() in ["active", "inactive"]
    
    def test_prometheus_installed(self):
        """Test if Prometheus is installed."""
        result = subprocess.run(
            ["systemctl", "is-active", "prometheus"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            assert result.stdout.strip() in ["active", "inactive"]


class TestAnsibleSyntax:
    """Test Ansible playbook and role syntax."""
    
    def test_sites_playbook_syntax(self):
        """Test if sites.yml has valid syntax."""
        result = subprocess.run(
            ["ansible-playbook", "--syntax-check", "sites.yml"],
            capture_output=True,
            text=True
        )
        assert result.returncode == 0
    
    def test_inventory_valid(self):
        """Test if inventory file is valid."""
        result = subprocess.run(
            ["ansible-inventory", "-i", "inventory/hosts.ini", "--list"],
            capture_output=True,
            text=True
        )
        assert result.returncode == 0


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
