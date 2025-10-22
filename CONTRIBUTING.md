# Contributing to CloudCurio Infrastructure

Thank you for your interest in contributing to CloudCurio Infrastructure! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Adding New Roles](#adding-new-roles)
- [Documentation](#documentation)

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Collaborate openly and transparently

## Getting Started

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/cloudcurio-infra.git
   cd cloudcurio-infra
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**

4. **Test your changes**
   ```bash
   ./scripts/check-requirements.sh
   ansible-playbook --syntax-check sites.yml
   python3 tests/test_roles.py
   ```

5. **Commit and push**
   ```bash
   git add .
   git commit -m "Add: description of your changes"
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**

## Development Setup

### Prerequisites
```bash
# Install Python dependencies
pip3 install -r requirements.txt

# Install Ansible collections
ansible-galaxy collection install community.docker
ansible-galaxy collection install community.general

# Install development tools
pip3 install black flake8 mypy pytest
```

### Testing Environment
We recommend testing changes in a VM or container before submitting:

```bash
# Using Docker
docker run -it ubuntu:22.04 /bin/bash

# Using Vagrant
vagrant init ubuntu/jammy64
vagrant up
```

## How to Contribute

### Bug Reports
- Use GitHub Issues
- Include system information (OS, Ansible version, etc.)
- Provide error messages and logs
- Include steps to reproduce

### Feature Requests
- Check existing issues first
- Clearly describe the feature and its benefits
- Provide use cases
- Be open to discussion

### Code Contributions
- Bug fixes
- New tool roles
- Documentation improvements
- Test coverage
- Utility scripts
- TUI enhancements

## Coding Standards

### Ansible Roles
```yaml
---
###############################################################################
# Role Name - Main Tasks
#
# Brief description of what this role does
#
# Tasks performed:
# 1. Task one
# 2. Task two
#
# Variables used:
# - variable_name: Description
#
# Requirements:
# - Ubuntu 20.04+
###############################################################################

# Task 1: Descriptive name
# Explain what this task does and why
- name: Install package
  apt:
    name: package-name
    state: present
    update_cache: yes
```

### Python Code
```python
"""
Module docstring explaining purpose.
"""

import required_modules


def function_name(param: str) -> bool:
    """
    Function docstring.
    
    Args:
        param: Description
        
    Returns:
        Description of return value
    """
    pass
```

### Shell Scripts
```bash
#!/bin/bash
###############################################################################
# Script Name - Brief Description
#
# Detailed description of what the script does.
#
# Usage:
#   ./script-name.sh [options]
###############################################################################

set -e  # Exit on error

# Clear, descriptive variable names
VARIABLE_NAME="value"

# Functions with comments
function_name() {
    local param=$1
    # Explain what this does
    echo "Output"
}
```

### Style Guidelines

1. **Ansible**
   - Use 2 spaces for indentation
   - Always include task names
   - Use `when` conditions appropriately
   - Include handlers where needed
   - Document variables in defaults/main.yml

2. **Python**
   - Follow PEP 8
   - Use type hints
   - Write docstrings
   - Keep functions focused
   - Use meaningful variable names

3. **Shell Scripts**
   - Use `set -e` for error handling
   - Quote variables
   - Use functions for reusability
   - Include usage information
   - Add comments for complex logic

## Testing Guidelines

### Before Submitting

1. **Syntax Validation**
   ```bash
   ansible-playbook --syntax-check sites.yml
   ```

2. **Lint Checks**
   ```bash
   ansible-lint roles/your-role/
   flake8 tui/
   ```

3. **Unit Tests**
   ```bash
   python3 tests/test_roles.py
   ```

4. **Integration Tests**
   ```bash
   ./scripts/verify-installation.sh
   ```

### Writing Tests

Add tests for new functionality:

```python
def test_new_feature(self):
    """Test description."""
    result = subprocess.run(
        ["command", "--version"],
        capture_output=True,
        text=True
    )
    assert result.returncode == 0
```

## Pull Request Process

1. **Update documentation**
   - README.md if adding new features
   - Role documentation
   - CHANGELOG.md

2. **Add tests**
   - Unit tests for new code
   - Integration tests for roles

3. **Ensure all tests pass**
   ```bash
   ./scripts/check-requirements.sh
   ansible-playbook --syntax-check sites.yml
   python3 tests/test_roles.py
   ```

4. **Write clear commit messages**
   ```
   Add: New feature description
   Fix: Bug fix description
   Update: Changes to existing feature
   Docs: Documentation updates
   Test: Test additions or modifications
   ```

5. **Create pull request**
   - Clear title and description
   - Reference related issues
   - List changes made
   - Include testing performed

6. **Respond to feedback**
   - Be open to suggestions
   - Make requested changes
   - Ask questions if unclear

## Adding New Roles

### Role Structure
```
roles/new-tool/
├── defaults/
│   └── main.yml        # Default variables
├── tasks/
│   └── main.yml        # Main tasks
├── handlers/
│   └── main.yml        # Handlers (if needed)
├── templates/
│   └── config.j2       # Config templates (if needed)
└── README.md           # Role documentation
```

### Role Template

**tasks/main.yml**:
```yaml
---
###############################################################################
# Tool Name - Installation Role
#
# Description of what this installs and configures.
#
# Requirements:
# - Operating system version
# - Dependencies
###############################################################################

- name: Install dependencies
  apt:
    name:
      - dependency1
      - dependency2
    state: present
    update_cache: yes

- name: Install tool
  # Installation tasks
  
- name: Configure tool
  # Configuration tasks
  
- name: Enable and start service
  systemd:
    name: service-name
    enabled: yes
    state: started
```

**defaults/main.yml**:
```yaml
---
# Default configuration variables
tool_version: "1.0.0"
tool_port: 8080
tool_enabled: true
```

### Checklist for New Roles

- [ ] Create role directory structure
- [ ] Write tasks/main.yml with comments
- [ ] Define defaults/main.yml
- [ ] Add handlers if needed
- [ ] Update sites.yml with new role
- [ ] Update group_vars/devops.yml
- [ ] Add to TUI installer (tui/installer.py)
- [ ] Update README.md tool list
- [ ] Add verification to scripts/verify-installation.sh
- [ ] Write tests
- [ ] Test installation
- [ ] Document any special requirements

## Documentation

### What to Document

1. **README updates**
   - Add new tools to the list
   - Update examples if needed
   - Add any new features

2. **Role documentation**
   - Purpose and description
   - Variables and their defaults
   - Requirements
   - Usage examples
   - Common issues

3. **Code comments**
   - Explain complex logic
   - Document why, not just what
   - Include links to relevant docs

4. **CHANGELOG**
   - Keep CHANGELOG.md updated
   - Follow semantic versioning

### Documentation Style

- Use clear, concise language
- Include code examples
- Add screenshots for UI features
- Link to relevant resources
- Keep formatting consistent

## Questions?

- Open an issue for questions
- Start a discussion in GitHub Discussions
- Check existing documentation

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to CloudCurio Infrastructure! 🎉
