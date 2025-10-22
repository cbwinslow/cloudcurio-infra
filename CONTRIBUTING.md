# Contributing to CloudCurio Infrastructure

Thank you for your interest in contributing to CloudCurio Infrastructure! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Submitting Changes](#submitting-changes)
- [Adding New DevOps Tools](#adding-new-devops-tools)
- [Documentation](#documentation)
- [Community](#community)

## Code of Conduct

### Our Pledge

In the interest of fostering an open and welcoming environment, we as contributors and maintainers pledge to make participation in our project and our community a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, sex characteristics, gender identity and expression, level of experience, education, socio-economic status, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

Examples of behavior that contributes to creating a positive environment include:

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

Examples of unacceptable behavior include:

- The use of sexualized language or imagery and unwelcome sexual attention or advances
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information without explicit permission
- Other conduct which could reasonably be considered inappropriate in a professional setting

### Our Responsibilities

Project maintainers are responsible for clarifying the standards of acceptable behavior and are expected to take appropriate and fair corrective action in response to any instances of unacceptable behavior.

### Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by contacting the project team. All complaints will be reviewed and investigated and will result in a response that is deemed necessary and appropriate to the circumstances.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/cloudcurio-infra.git
   cd cloudcurio-infra
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/cbwinslow/cloudcurio-infra.git
   ```
4. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

### Prerequisites

- Ansible 2.9 or higher
- Python 3.6 or higher
- Git
- A Linux or macOS development environment

### Install Dependencies

```bash
# Install Ansible
pip install ansible

# Install additional Python dependencies
pip install -r requirements.txt

# Install ansible-lint for code quality
pip install ansible-lint
```

### Verify Installation

```bash
ansible --version
ansible-lint --version
```

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior**
- **Actual behavior**
- **Environment details** (OS, Ansible version, etc.)
- **Any relevant logs or error messages**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear title and description**
- **Use case** and benefits
- **Possible implementation** approach
- **Alternative solutions** considered

### Pull Requests

1. Ensure your code follows the [Coding Standards](#coding-standards)
2. Update documentation as needed
3. Add tests for new functionality
4. Ensure all tests pass
5. Write clear commit messages
6. Reference any related issues

## Coding Standards

### Ansible Best Practices

- Follow [Ansible best practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- Use meaningful variable names
- Keep tasks simple and focused
- Use handlers for service restarts
- Tag tasks appropriately

### YAML Formatting

```yaml
# Use 2 spaces for indentation
- name: Example task
  apt:
    name: package-name
    state: present
  tags:
    - packages
```

### Role Structure

```
roles/tool-name/
├── README.md
├── defaults/
│   └── main.yml
├── tasks/
│   └── main.yml
├── handlers/
│   └── main.yml
├── templates/
├── files/
└── meta/
    └── main.yml
```

### Naming Conventions

- **Roles**: Use lowercase with hyphens (e.g., `prometheus-server`)
- **Variables**: Use snake_case (e.g., `prometheus_version`)
- **Tasks**: Use descriptive names (e.g., "Install Prometheus binary")
- **Files**: Use lowercase with hyphens (e.g., `prometheus-config.yml`)

## Testing Guidelines

### Local Testing

Test your changes locally before submitting:

```bash
# Lint your playbooks
ansible-lint playbooks/your-playbook.yml

# Syntax check
ansible-playbook --syntax-check playbooks/your-playbook.yml

# Dry run
ansible-playbook --check playbooks/your-playbook.yml

# Run against test environment
ansible-playbook -i inventory/test playbooks/your-playbook.yml
```

### Role Testing

Each role should include:

- **README.md** with usage examples
- **defaults/main.yml** with documented variables
- **Example playbook** showing how to use the role

## Submitting Changes

### Commit Message Format

```
type(scope): subject

body

footer
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Example:**
```
feat(prometheus): add Prometheus monitoring role

- Add installation tasks for Prometheus
- Configure systemd service
- Add default alerting rules
- Update documentation

Closes #123
```

### Pull Request Process

1. **Update documentation** for any changed functionality
2. **Add tests** for new features
3. **Run linting** and fix any issues:
   ```bash
   ansible-lint
   ```
4. **Update DEVOPS_TOOLS_REFERENCE.md** if adding new tools
5. **Request review** from maintainers
6. **Address feedback** promptly
7. **Squash commits** if requested

## Adding New DevOps Tools

When adding a new DevOps tool role:

1. **Create role structure**:
   ```bash
   ansible-galaxy init roles/tool-name
   ```

2. **Implement core tasks**:
   - Installation
   - Configuration
   - Service management
   - Health checks

3. **Document the role**:
   - Add README.md with usage instructions
   - Document all variables in defaults/main.yml
   - Provide example playbook

4. **Update reference documentation**:
   - Add tool to DEVOPS_TOOLS_REFERENCE.md
   - Include category, description, and key features
   - Add example usage

5. **Test thoroughly**:
   - Test on multiple distributions
   - Verify idempotency
   - Check service health

## Documentation

### Documentation Standards

- Use **Markdown** for all documentation
- Include **code examples** with proper formatting
- Keep documentation **up-to-date** with code changes
- Use **clear, concise language**
- Include **screenshots** where helpful

### Code Examples

Always use proper code block formatting:

```yaml
# Good example with syntax highlighting
- name: Install package
  apt:
    name: example
    state: present
```

```bash
# Shell commands with bash highlighting
ansible-playbook site.yml
```

### Updating Documentation

When making changes, update relevant documentation:

- **README.md** - For major features or changes
- **DEVOPS_TOOLS_REFERENCE.md** - When adding/modifying tools
- **Role README.md** - When changing role functionality
- **CONTRIBUTING.md** - When changing contribution process

## Community

### Getting Help

- **GitHub Issues** - For bugs and feature requests
- **GitHub Discussions** - For questions and general discussion
- **Pull Requests** - For code contributions

### Stay Updated

- Watch the repository for updates
- Read commit messages and pull requests
- Participate in discussions

Thank you for contributing to CloudCurio Infrastructure! Your efforts help make this project better for everyone.

---

**[Back to README](README.md)** | **[View DevOps Tools Reference](DEVOPS_TOOLS_REFERENCE.md)**
