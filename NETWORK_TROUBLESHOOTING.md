# Network Troubleshooting Guide

This guide provides comprehensive information about network troubleshooting, diagnostics, and techniques for overcoming network hurdles in CloudCurio Infrastructure.

## Overview

CloudCurio Infrastructure includes robust networking capabilities and tools to help overcome common network challenges:

- **ZeroTier Mesh VPN**: Create secure overlay networks
- **SSH Tunnels**: Bypass restrictions and create secure connections
- **Network Diagnostics**: Comprehensive troubleshooting tools
- **Firewall Management**: Easy firewall configuration
- **Proxy Support**: HTTP/SOCKS proxy capabilities
- **Network Monitoring**: Continuous health monitoring

## Common Network Hurdles and Solutions

### 1. Restricted Network Access

**Problem**: Cannot access certain ports or services due to firewall restrictions.

**Solutions**:

#### SSH Tunneling
Create SSH tunnels to bypass restrictions:
```bash
# Interactive SSH tunnel helper
bash scripts/networking/ssh_tunnel_helper.sh

# Manual local port forward (access remote service locally)
ssh -L 8080:remote-host:80 user@ssh-server

# Manual remote port forward (expose local service remotely)
ssh -R 8080:localhost:80 user@ssh-server

# SOCKS proxy for routing all traffic
ssh -D 9050 user@ssh-server
```

#### ZeroTier Mesh Network
Create a virtual private network that bypasses local network restrictions:
```bash
# Install ZeroTier
bash scripts/installers/networking/install_zerotier.sh

# Join network
sudo zerotier-cli join <network_id>

# Test connectivity
bash scripts/networking/zerotier_connectivity_test.sh
```

### 2. DNS Resolution Issues

**Problem**: Cannot resolve domain names.

**Solutions**:

#### Fix DNS with Ansible
```bash
ansible-playbook -i inventory/hosts.ini playbooks/network_troubleshooting.yml
```

#### Manual DNS Fix
```bash
# Backup current configuration
sudo cp /etc/resolv.conf /etc/resolv.conf.backup

# Use public DNS servers
sudo tee /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
EOF

# Test DNS
nslookup google.com
```

### 3. Firewall Blocking Connections

**Problem**: Local firewall preventing connections.

**Solutions**:

#### Use Firewall Helper
```bash
bash scripts/networking/firewall_helper.sh
```

#### Manual Firewall Configuration
```bash
# Check firewall status
sudo ufw status verbose

# Enable firewall with essential ports
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp     # SSH
sudo ufw allow 9993/udp   # ZeroTier
sudo ufw enable

# Allow specific services
sudo ufw allow 80/tcp     # HTTP
sudo ufw allow 443/tcp    # HTTPS
sudo ufw allow 3000/tcp   # Grafana
sudo ufw allow 9090/tcp   # Prometheus

# Allow from specific network
sudo ufw allow from 172.28.0.0/16
```

### 4. Intermittent Connectivity

**Problem**: Network connection drops frequently.

**Solutions**:

#### Enable Network Health Monitoring
```bash
ansible-playbook -i inventory/hosts.ini playbooks/advanced_networking_setup.yml
```

This sets up:
- Continuous connectivity monitoring
- Automatic recovery attempts
- Detailed logging
- Service restart on failures

#### Manual Monitoring
```bash
# Monitor network in real-time
watch -n 5 'ping -c 3 8.8.8.8 && echo "Internet: OK" || echo "Internet: DOWN"'

# Check network logs
sudo journalctl -u zerotier-one -f
sudo tail -f /var/log/network-health.log
```

### 5. Cannot Reach Other Nodes

**Problem**: Cannot connect to other servers in the infrastructure.

**Solutions**:

#### Test Connectivity
```bash
# Run comprehensive network diagnostics
bash scripts/networking/network_diagnostics.sh

# Test ZeroTier mesh connectivity
bash scripts/networking/zerotier_connectivity_test.sh 172.28.0.1 172.28.0.10

# Use Ansible to test all nodes
ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml
```

#### Troubleshoot Routing
```bash
# Check routing table
ip route show

# Check ZeroTier routes
sudo zerotier-cli listnetworks

# Trace route to destination
traceroute <destination-ip>
mtr <destination-ip>
```

### 6. High Latency or Packet Loss

**Problem**: Slow connection or dropped packets.

**Solutions**:

#### Diagnose Issues
```bash
# Test latency
ping -c 100 <destination>

# Detailed network analysis
mtr --report <destination>

# Test bandwidth
iperf3 -s  # On server
iperf3 -c <server-ip>  # On client
```

#### Optimize Network
```bash
# Enable TCP optimizations
sudo sysctl -w net.ipv4.tcp_window_scaling=1
sudo sysctl -w net.core.rmem_max=134217728
sudo sysctl -w net.core.wmem_max=134217728

# For ZeroTier, ensure UDP 9993 is not blocked
sudo ufw allow 9993/udp
```

## Network Diagnostic Tools

### 1. Network Diagnostics Script
Comprehensive network health check:
```bash
bash scripts/networking/network_diagnostics.sh
```

**Checks**:
- Internet connectivity
- DNS resolution
- Network interfaces
- Routing table
- ZeroTier status
- Firewall rules
- Listening ports
- Common service connectivity

### 2. ZeroTier Connectivity Test
Specifically test mesh network:
```bash
bash scripts/networking/zerotier_connectivity_test.sh
```

**Tests**:
- ZeroTier node status
- Joined networks
- Peer connectivity
- Network interfaces
- Service status

### 3. Network Troubleshooting Playbook
Automated diagnostics and fixes:
```bash
ansible-playbook -i inventory/hosts.ini playbooks/network_troubleshooting.yml
```

**Actions**:
- Tests all network components
- Fixes DNS if needed
- Verifies ZeroTier
- Checks firewall
- Tests external connectivity
- Generates network report

## Advanced Networking Features

### 1. SSH Tunnels and Port Forwarding

Create persistent tunnels for accessing services:

```bash
# Setup network tunnels with Ansible
ansible-playbook -i inventory/hosts.ini playbooks/setup_network_tunnels.yml

# Interactive tunnel creation
bash scripts/networking/ssh_tunnel_helper.sh
```

**Use Cases**:
- Access internal web services remotely
- Bypass corporate firewalls
- Secure unencrypted connections
- Connect services across networks

### 2. Proxy Configuration

Setup HTTP/SOCKS proxies for routing traffic:

```bash
# Deploy proxy infrastructure
ansible-playbook -i inventory/hosts.ini playbooks/advanced_networking_setup.yml
```

**Configured Services**:
- TinyProxy (HTTP proxy on port 8888)
- ProxyChains (SOCKS proxy support)
- Squid (Advanced HTTP proxy)

**Using ProxyChains**:
```bash
# Configure proxychains
sudo nano /etc/proxychains.conf

# Use with any command
proxychains curl https://example.com
proxychains git clone https://github.com/user/repo.git
```

### 3. Network Bypass Script

Automatically try multiple network paths:

```bash
# Use network bypass helper
/usr/local/bin/network-bypass curl https://example.com

# This tries:
# 1. Direct connection
# 2. Through ZeroTier
# 3. Through proxy chains
```

### 4. AutoSSH for Persistent Tunnels

Create tunnels that automatically reconnect:

```bash
# AutoSSH wrapper is installed with playbook
ansible-playbook -i inventory/hosts.ini playbooks/setup_network_tunnels.yml

# Use AutoSSH manually
autossh -M 0 -N -L 8080:localhost:80 user@remote-host
```

## Network Monitoring

### Continuous Health Monitoring

The network health monitor continuously checks connectivity:

```bash
# Enable with playbook
ansible-playbook -i inventory/hosts.ini playbooks/advanced_networking_setup.yml

# Check logs
sudo tail -f /var/log/network-health.log

# Service control
sudo systemctl status network-health-monitor
sudo systemctl restart network-health-monitor
```

**Features**:
- Tests internet connectivity every minute
- Monitors DNS resolution
- Tracks ZeroTier status
- Attempts automatic recovery
- Detailed logging

### Network Performance Monitoring

```bash
# Install monitoring stack
bash scripts/installers/monitoring/install_monitoring_stack.sh

# Monitor with Grafana
# Access at http://localhost:3000
# Default credentials: admin/admin

# View metrics in Prometheus
# Access at http://localhost:9090
```

## Best Practices

### 1. Always Test Connectivity First
```bash
# Before deploying services
bash scripts/networking/network_diagnostics.sh
ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml
```

### 2. Use ZeroTier for Distributed Infrastructure
- Creates secure overlay network
- Bypasses NAT and firewall issues
- Provides consistent IP addressing
- Works across different networks

### 3. Document Network Configuration
Keep track of:
- Network IDs
- IP address assignments
- Firewall rules
- Tunnel configurations
- Proxy settings

### 4. Regular Network Audits
```bash
# Weekly network health check
0 2 * * 1 /path/to/scripts/networking/network_diagnostics.sh >> /var/log/network-audit.log 2>&1

# Daily ZeroTier connectivity test
0 */6 * * * /path/to/scripts/networking/zerotier_connectivity_test.sh >> /var/log/zerotier-test.log 2>&1
```

### 5. Secure Network Configurations
- Always use SSH key authentication
- Enable UFW firewall
- Use VPN for sensitive traffic
- Regularly update network tools
- Monitor for unauthorized access

## Troubleshooting Checklist

When facing network issues, work through this checklist:

- [ ] Test basic connectivity: `ping 8.8.8.8`
- [ ] Test DNS resolution: `nslookup google.com`
- [ ] Check network interfaces: `ip addr show`
- [ ] Verify routing table: `ip route show`
- [ ] Test ZeroTier status: `sudo zerotier-cli info`
- [ ] Check firewall rules: `sudo ufw status`
- [ ] Review service logs: `journalctl -xe`
- [ ] Test with network diagnostics: `bash scripts/networking/network_diagnostics.sh`
- [ ] Try SSH tunnel: `bash scripts/networking/ssh_tunnel_helper.sh`
- [ ] Run Ansible troubleshooting: `ansible-playbook -i inventory/hosts.ini playbooks/network_troubleshooting.yml`

## Quick Reference Commands

```bash
# Network diagnostics
bash scripts/networking/network_diagnostics.sh

# ZeroTier connectivity test
bash scripts/networking/zerotier_connectivity_test.sh

# SSH tunnel helper
bash scripts/networking/ssh_tunnel_helper.sh

# Firewall configuration
bash scripts/networking/firewall_helper.sh

# Ansible network tests
ansible-playbook -i inventory/hosts.ini playbooks/test_network_connectivity.yml

# Ansible troubleshooting
ansible-playbook -i inventory/hosts.ini playbooks/network_troubleshooting.yml

# Setup advanced networking
ansible-playbook -i inventory/hosts.ini playbooks/advanced_networking_setup.yml

# Setup SSH tunnels
ansible-playbook -i inventory/hosts.ini playbooks/setup_network_tunnels.yml
```

## Additional Resources

- [ZeroTier Documentation](https://docs.zerotier.com/)
- [SSH Tunneling Guide](https://www.ssh.com/academy/ssh/tunneling)
- [Linux Network Troubleshooting](https://www.redhat.com/sysadmin/network-troubleshooting)
- [UFW Firewall Guide](https://help.ubuntu.com/community/UFW)

## Support

For network-related issues:
1. Run all diagnostic scripts
2. Check service logs
3. Review firewall rules
4. Test with multiple tools
5. Document the issue with diagnostic output
6. Open an issue with full context
