# Known Issues and Future Improvements

## Docker Module Namespace

Several roles use Docker modules without the full collection namespace. While these work with current Ansible installations (the short names are aliased), for better compatibility consider updating:

- `docker_image` → `community.docker.docker_image`
- `docker_container` → `community.docker.docker_container`

Affected roles:
- anythingllm
- bitwarden  
- gitea
- gitlab
- keycloak
- kong
- n8n
- nextcloud
- owncloud
- openwebui
- supabase
- uptime-kuma
- guacamole

To use the fully qualified collection names, ensure the `community.docker` collection is installed:

```bash
ansible-galaxy collection install community.docker
```

## Security Considerations

1. **Default Passwords**: Many roles use placeholder passwords (`changeme`). Before production use:
   - Create an Ansible Vault file: `ansible-vault create group_vars/vault.yml`
   - Add secure passwords to the vault
   - Reference them in `group_vars/devops.yml`

2. **Port Conflicts**: Some roles may bind to common ports. Review and adjust in `group_vars/devops.yml`:
   - Multiple services on port 80
   - Multiple services on port 8080
   - Check the DEVOPS_TOOLS_README.md for default port assignments

3. **File Permissions**: Some directory creation tasks could benefit from explicit owner/group settings for enhanced security.

## Optional Enhancements

### Role Improvements

1. **Health Checks**: Add health check URLs/commands to verify service availability
2. **Backup Tasks**: Add backup/restore functionality for stateful services
3. **Log Rotation**: Configure log rotation for services that generate logs
4. **Firewall Rules**: Add UFW/iptables rules when firewall is enabled

### Testing

1. **Molecule Tests**: Add Molecule test scenarios for critical roles
2. **CI/CD**: Add GitHub Actions workflow to test playbook syntax
3. **Integration Tests**: Test inter-service dependencies (e.g., Grafana + Prometheus)

### Documentation

1. **Architecture Diagrams**: Add visual diagrams showing how services interconnect
2. **Troubleshooting Guide**: Expand troubleshooting section with common errors
3. **Performance Tuning**: Add guidelines for production-scale deployments

## Workarounds

### If Docker modules fail

If you encounter issues with Docker modules:

```bash
# Install community.docker collection
ansible-galaxy collection install community.docker

# Or use shell/command modules as fallback
# Example in a custom playbook:
- name: Pull image
  command: docker pull imagename:tag
  
- name: Run container  
  command: docker run -d --name container imagename:tag
```

### If specific tools are unavailable

Some tools may have changed repositories or installation methods. In such cases:

1. Check the tool's official documentation for current installation method
2. Update the role's tasks accordingly
3. Set `ignore_errors: yes` to continue with other installations

## Compatibility

Tested with:
- Ansible 2.9+
- Ubuntu 20.04, 22.04
- Debian 10, 11

May require adjustments for:
- RHEL/CentOS (different package names, paths)
- Older Ubuntu/Debian versions
- ARM architecture (some tools lack ARM builds)

## Contributing

When submitting improvements:

1. Test changes with `ansible-playbook --syntax-check`
2. Run in check mode: `ansible-playbook --check`
3. Update relevant documentation
4. Follow existing role structure and naming conventions
