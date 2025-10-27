# Networking Scripts

This directory contains powerful networking diagnostic, troubleshooting, and helper tools for CloudCurio Infrastructure.

## Available Scripts

### 1. Network Diagnostics (`network_diagnostics.sh`)

Comprehensive network health check and diagnostics.

**Features:**
- Tests internet connectivity
- Validates DNS resolution
- Displays network interfaces
- Shows routing table
- Checks ZeroTier status
- Displays firewall status
- Lists listening ports
- Tests connectivity to common services

**Usage:**
```bash
bash network_diagnostics.sh
```

**Output Example:**
```
=== Internet Connectivity ===
✓ Internet connectivity: OK
✓ DNS resolution: OK

=== Network Interfaces ===
eth0             UP             192.168.1.100/24
zt0              UP             172.28.0.1/24

=== ZeroTier Status ===
200 info xxxxxx 1.10.6 ONLINE
```

### 2. ZeroTier Connectivity Test (`zerotier_connectivity_test.sh`)

Specifically test ZeroTier mesh network connectivity.

**Features:**
- Displays ZeroTier node information
- Lists joined networks
- Tests connectivity to mesh peers
- Shows ZeroTier interfaces
- Verifies service status

**Usage:**
```bash
# Test default IPs
bash zerotier_connectivity_test.sh

# Test custom IPs
bash zerotier_connectivity_test.sh 172.28.0.1 172.28.0.10 172.28.0.20
```

**Output Example:**
```
=== ZeroTier Node Information ===
200 info xxxxxx 1.10.6 ONLINE

=== Testing Connectivity to Mesh Peers ===
✓ Can reach 172.28.0.1
✓ Can reach 172.28.0.10
✗ Cannot reach 172.28.0.20

=== Connectivity Summary ===
Reachable nodes: 2
Unreachable nodes: 1
```

### 3. SSH Tunnel Helper (`ssh_tunnel_helper.sh`)

Interactive tool for creating SSH tunnels to bypass network restrictions.

**Features:**
- Local port forwarding
- Remote port forwarding
- SOCKS proxy creation
- Reverse SSH tunnels
- List active tunnels
- Close tunnels

**Usage:**
```bash
bash ssh_tunnel_helper.sh
```

**Menu Options:**
1. Create local port forward (Local → Remote)
2. Create remote port forward (Remote → Local)
3. Create dynamic SOCKS proxy
4. Create reverse SSH tunnel
5. List active SSH tunnels
6. Close SSH tunnel

**Examples:**

**Local Port Forward:**
```
Local port: 8080
Remote host: internal-server
Remote port: 80
SSH server: bastion.example.com

Creates tunnel: localhost:8080 → internal-server:80 via bastion
```

**SOCKS Proxy:**
```
SOCKS proxy port: 9050
SSH server: proxy-server.example.com

Creates SOCKS5 proxy on localhost:9050
Configure browser to use this proxy
```

### 4. Firewall Helper (`firewall_helper.sh`)

Interactive firewall configuration tool.

**Features:**
- Enable basic firewall
- Add ZeroTier ports
- Add SSH ports
- Add Docker ports
- Add monitoring ports
- Add web server ports
- Add custom ports
- Remove rules
- Show all rules

**Usage:**
```bash
bash firewall_helper.sh
```

**Menu Options:**
1. Enable basic firewall with essential services
2. Add ZeroTier ports (UDP 9993)
3. Add SSH port (TCP 22)
4. Add Docker ports
5. Add monitoring ports (Prometheus, Grafana)
6. Add web server ports (HTTP/HTTPS)
7. Allow custom port
8. Remove rule
9. Show all rules

**Examples:**

**Basic Setup:**
```bash
# Run firewall helper
bash firewall_helper.sh

# Choose option 1: Enable basic firewall
# Choose option 2: Add ZeroTier ports
# Choose option 3: Add SSH port
```

**Custom Port:**
```
Port number: 8080
Protocol: tcp
Comment: Custom App

Result: Allows TCP port 8080 with comment
```

## Common Use Cases

### 1. Troubleshoot Network Issues

When experiencing network problems:

```bash
# Step 1: Run comprehensive diagnostics
bash network_diagnostics.sh

# Step 2: Check ZeroTier connectivity
bash zerotier_connectivity_test.sh

# Step 3: Check firewall
bash firewall_helper.sh  # Choose option 9 to show rules
```

### 2. Bypass Network Restrictions

When you need to access blocked resources:

```bash
# Create SOCKS proxy through unrestricted host
bash ssh_tunnel_helper.sh
# Choose option 3: SOCKS proxy
# Configure browser to use localhost:9050 as SOCKS5 proxy
```

### 3. Access Internal Services

When you need to access services behind a firewall:

```bash
# Create local port forward
bash ssh_tunnel_helper.sh
# Choose option 1: Local port forward
# Example: Forward localhost:8080 to internal-web:80
# Now access http://localhost:8080
```

### 4. Expose Local Service

When you need to expose a local service remotely:

```bash
# Create remote port forward
bash ssh_tunnel_helper.sh
# Choose option 2: Remote port forward
# Example: Expose local:8080 on remote:8080
# Remote users access remote-host:8080
```

### 5. Setup Secure Access

Configure firewall for secure operations:

```bash
bash firewall_helper.sh
# Option 1: Enable basic firewall
# Option 2: Add ZeroTier ports
# Option 3: Add SSH port
# Option 5: Add monitoring ports
```

## Integration with Ansible

These scripts are also integrated into Ansible playbooks:

```bash
# Setup network troubleshooting tools
ansible-playbook -i ../inventory/hosts.ini ../playbooks/setup_network_tunnels.yml

# Run network troubleshooting
ansible-playbook -i ../inventory/hosts.ini ../playbooks/network_troubleshooting.yml

# Setup advanced networking
ansible-playbook -i ../inventory/hosts.ini ../playbooks/advanced_networking_setup.yml
```

## Automation Examples

### Regular Network Health Checks

Add to crontab:
```bash
# Run network diagnostics every 6 hours
0 */6 * * * /path/to/scripts/networking/network_diagnostics.sh >> /var/log/network-check.log 2>&1

# Test ZeroTier connectivity daily
0 2 * * * /path/to/scripts/networking/zerotier_connectivity_test.sh >> /var/log/zt-check.log 2>&1
```

### Automatic Tunnel Creation

Create a systemd service for persistent tunnels:
```bash
# Use AutoSSH for auto-reconnecting tunnels
autossh -M 0 -N -L 8080:internal:80 user@bastion -o "ServerAliveInterval=30"
```

### Alert on Network Issues

Create a monitoring script:
```bash
#!/bin/bash
# check_network.sh
if ! bash /path/to/network_diagnostics.sh > /dev/null 2>&1; then
    echo "Network issues detected!" | mail -s "Network Alert" admin@example.com
fi
```

## Troubleshooting

### Script Permission Issues

```bash
# Make scripts executable
chmod +x network_diagnostics.sh
chmod +x zerotier_connectivity_test.sh
chmod +x ssh_tunnel_helper.sh
chmod +x firewall_helper.sh
```

### ZeroTier Not Found

```bash
# Install ZeroTier first
bash ../installers/networking/install_zerotier.sh
```

### UFW Not Found

```bash
# Install UFW
sudo apt update
sudo apt install -y ufw
```

### SSH Tunnel Connection Issues

```bash
# Test SSH connectivity first
ssh user@remote-host

# Use verbose mode for debugging
ssh -vvv -L 8080:localhost:80 user@remote-host

# Check SSH server configuration
sudo nano /etc/ssh/sshd_config
# Ensure: AllowTcpForwarding yes
```

## Best Practices

1. **Regular Diagnostics**: Run network diagnostics regularly
2. **Document Tunnels**: Keep track of SSH tunnels you create
3. **Secure Firewall**: Always enable firewall with essential ports only
4. **Test After Changes**: Always test connectivity after firewall changes
5. **Monitor Logs**: Check logs for tunnel and connection issues
6. **Use Keys**: Always use SSH keys instead of passwords
7. **Close Unused Tunnels**: Close SSH tunnels when not needed

## Advanced Tips

### Persistent Tunnels with AutoSSH

```bash
# Install AutoSSH
sudo apt install autossh

# Create persistent tunnel
autossh -M 0 -f -N -L 8080:localhost:80 user@remote \
    -o "ServerAliveInterval=30" \
    -o "ServerAliveCountMax=3"
```

### ProxyChains for Network Bypass

```bash
# Configure proxychains
sudo nano /etc/proxychains.conf

# Add SOCKS proxy
[ProxyList]
socks5 127.0.0.1 9050

# Use with any command
proxychains curl https://example.com
proxychains git clone https://github.com/user/repo.git
```

### Multiple Network Paths

```bash
# Use network bypass helper (installed by advanced networking playbook)
/usr/local/bin/network-bypass curl https://example.com

# This tries multiple connection methods automatically
```

## Related Documentation

- [Network Troubleshooting Guide](../NETWORK_TROUBLESHOOTING.md)
- [Testing Guide](../TESTING_GUIDE.md)
- [Quick Reference](../QUICK_REFERENCE.md)

## Support

For networking issues:
1. Run all diagnostic scripts
2. Check service logs: `sudo journalctl -u zerotier-one`
3. Review firewall rules: `sudo ufw status verbose`
4. Test basic connectivity: `ping 8.8.8.8`
5. Consult the Network Troubleshooting Guide
6. Open an issue with diagnostic output
