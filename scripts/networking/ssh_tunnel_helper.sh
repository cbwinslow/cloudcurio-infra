#!/bin/bash
# SSH tunnel helper script for bypassing network restrictions
set -e

# Security: Enable audit logging
AUDIT_LOG="/var/log/ssh-tunnel-helper.log"

audit_log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local user=${SUDO_USER:-$USER}
    echo "[$timestamp] USER=$user ACTION=$1 STATUS=$2 DETAILS=$3" >> "$AUDIT_LOG" 2>/dev/null || true
}

# Input validation functions
validate_port() {
    local port=$1
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "✗ Invalid port number: $port (must be 1-65535)"
        return 1
    fi
    return 0
}

validate_hostname() {
    local hostname=$1
    # Allow: alphanumeric, dots, hyphens, underscores, @
    # This matches typical hostnames and user@host patterns
    if ! [[ "$hostname" =~ ^[a-zA-Z0-9._@-]+$ ]]; then
        echo "✗ Invalid hostname format: $hostname"
        echo "  Allowed: letters, numbers, dots, hyphens, underscores, @"
        return 1
    fi
    return 0
}

echo "=============================================="
echo "SSH Tunnel Helper"
echo "=============================================="
echo ""

show_usage() {
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  1) Create local port forward (Local -> Remote)"
    echo "  2) Create remote port forward (Remote -> Local)"
    echo "  3) Create dynamic SOCKS proxy"
    echo "  4) Create reverse SSH tunnel"
    echo "  5) List active SSH tunnels"
    echo "  6) Close SSH tunnel"
    echo "  0) Exit"
    echo ""
}

list_tunnels() {
    echo "Active SSH tunnels:"
    ps aux | grep "ssh.*-[LRD]" | grep -v grep || echo "No active tunnels found"
}

create_local_forward() {
    read -p "Local port: " local_port
    read -p "Remote host: " remote_host
    read -p "Remote port: " remote_port
    read -p "SSH server (user@host): " ssh_server
    
    # Validate inputs
    if ! validate_port "$local_port"; then
        audit_log "CREATE_LOCAL_FORWARD" "FAILED" "Invalid local port: $local_port"
        return 1
    fi
    if ! validate_hostname "$remote_host"; then
        audit_log "CREATE_LOCAL_FORWARD" "FAILED" "Invalid remote host: $remote_host"
        return 1
    fi
    if ! validate_port "$remote_port"; then
        audit_log "CREATE_LOCAL_FORWARD" "FAILED" "Invalid remote port: $remote_port"
        return 1
    fi
    if ! validate_hostname "$ssh_server"; then
        audit_log "CREATE_LOCAL_FORWARD" "FAILED" "Invalid SSH server: $ssh_server"
        return 1
    fi
    
    echo "Creating local port forward..."
    echo "Local port $local_port -> $remote_host:$remote_port via $ssh_server"
    
    # Use proper quoting to prevent command injection
    if ssh -f -N -L "${local_port}:${remote_host}:${remote_port}" "${ssh_server}"; then
        echo "✓ Tunnel created successfully!"
        echo "You can now connect to localhost:$local_port"
        audit_log "CREATE_LOCAL_FORWARD" "SUCCESS" "Local:$local_port -> $remote_host:$remote_port via $ssh_server"
        return 0
    else
        echo "✗ Failed to create tunnel"
        audit_log "CREATE_LOCAL_FORWARD" "FAILED" "SSH command failed"
        return 1
    fi
}

create_remote_forward() {
    read -p "Remote port: " remote_port
    read -p "Local host: " local_host
    read -p "Local port: " local_port
    read -p "SSH server (user@host): " ssh_server
    
    # Validate inputs
    if ! validate_port "$remote_port"; then
        audit_log "CREATE_REMOTE_FORWARD" "FAILED" "Invalid remote port: $remote_port"
        return 1
    fi
    if ! validate_hostname "$local_host"; then
        audit_log "CREATE_REMOTE_FORWARD" "FAILED" "Invalid local host: $local_host"
        return 1
    fi
    if ! validate_port "$local_port"; then
        audit_log "CREATE_REMOTE_FORWARD" "FAILED" "Invalid local port: $local_port"
        return 1
    fi
    if ! validate_hostname "$ssh_server"; then
        audit_log "CREATE_REMOTE_FORWARD" "FAILED" "Invalid SSH server: $ssh_server"
        return 1
    fi
    
    echo "Creating remote port forward..."
    echo "Remote port $remote_port -> $local_host:$local_port"
    
    # Use proper quoting to prevent command injection
    if ssh -f -N -R "${remote_port}:${local_host}:${local_port}" "${ssh_server}"; then
        echo "✓ Tunnel created successfully!"
        audit_log "CREATE_REMOTE_FORWARD" "SUCCESS" "Remote:$remote_port -> $local_host:$local_port via $ssh_server"
        return 0
    else
        echo "✗ Failed to create tunnel"
        audit_log "CREATE_REMOTE_FORWARD" "FAILED" "SSH command failed"
        return 1
    fi
}

create_socks_proxy() {
    read -p "SOCKS proxy port (default 8080): " socks_port
    socks_port=${socks_port:-8080}
    read -p "SSH server (user@host): " ssh_server
    
    # Validate inputs
    if ! validate_port "$socks_port"; then
        audit_log "CREATE_SOCKS_PROXY" "FAILED" "Invalid SOCKS port: $socks_port"
        return 1
    fi
    if ! validate_hostname "$ssh_server"; then
        audit_log "CREATE_SOCKS_PROXY" "FAILED" "Invalid SSH server: $ssh_server"
        return 1
    fi
    
    echo "Creating SOCKS proxy on port $socks_port..."
    
    # Use proper quoting to prevent command injection
    if ssh -f -N -D "${socks_port}" "${ssh_server}"; then
        echo "✓ SOCKS proxy created successfully!"
        echo "Configure your browser/application to use SOCKS5 proxy:"
        echo "  Host: localhost"
        echo "  Port: $socks_port"
        audit_log "CREATE_SOCKS_PROXY" "SUCCESS" "Port:$socks_port via $ssh_server"
        return 0
    else
        echo "✗ Failed to create SOCKS proxy"
        audit_log "CREATE_SOCKS_PROXY" "FAILED" "SSH command failed"
        return 1
    fi
}

create_reverse_tunnel() {
    read -p "Remote port (for reverse connection): " remote_port
    read -p "SSH server (user@host): " ssh_server
    
    # Validate inputs
    if ! validate_port "$remote_port"; then
        audit_log "CREATE_REVERSE_TUNNEL" "FAILED" "Invalid remote port: $remote_port"
        return 1
    fi
    if ! validate_hostname "$ssh_server"; then
        audit_log "CREATE_REVERSE_TUNNEL" "FAILED" "Invalid SSH server: $ssh_server"
        return 1
    fi
    
    # Security warning for reverse tunnels
    echo ""
    echo "⚠️  SECURITY WARNING ⚠️"
    echo "Reverse tunnels expose your local SSH (port 22) to the remote server."
    echo "Ensure the remote server is trusted and properly secured."
    echo "Consider using SSH key authentication and fail2ban on this machine."
    echo ""
    read -p "Do you understand the risks and want to continue? (yes/no): " confirm
    
    if [ "$confirm" != "yes" ]; then
        echo "Operation cancelled."
        audit_log "CREATE_REVERSE_TUNNEL" "CANCELLED" "User declined risk acknowledgment"
        return 1
    fi
    
    echo "Creating reverse SSH tunnel..."
    echo "Remote users can connect to $ssh_server:$remote_port to reach this machine"
    
    # Use proper quoting to prevent command injection
    if ssh -f -N -R "${remote_port}:localhost:22" "${ssh_server}"; then
        echo "✓ Reverse tunnel created successfully!"
        echo "From remote machine, connect with: ssh -p $remote_port user@localhost"
        audit_log "CREATE_REVERSE_TUNNEL" "SUCCESS" "Remote:$remote_port -> localhost:22 via $ssh_server"
        return 0
    else
        echo "✗ Failed to create reverse tunnel"
        audit_log "CREATE_REVERSE_TUNNEL" "FAILED" "SSH command failed"
        return 1
    fi
}

close_tunnel() {
    echo "Active tunnels:"
    ps aux | grep "ssh.*-[LRD]" | grep -v grep | nl
    
    read -p "Enter PID to close: " pid
    
    # Validate PID is numeric
    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo "✗ Invalid PID: must be a number"
        audit_log "CLOSE_TUNNEL" "FAILED" "Invalid PID: $pid"
        return 1
    fi
    
    if [ -n "$pid" ]; then
        if kill "$pid" 2>/dev/null; then
            echo "✓ Tunnel closed"
            audit_log "CLOSE_TUNNEL" "SUCCESS" "PID:$pid"
            return 0
        else
            echo "✗ Failed to close tunnel (PID may not exist or insufficient permissions)"
            audit_log "CLOSE_TUNNEL" "FAILED" "Cannot kill PID:$pid"
            return 1
        fi
    fi
}

# Main menu
show_usage

read -p "Choose an option [0-6]: " choice

case $choice in
    1)
        create_local_forward
        ;;
    2)
        create_remote_forward
        ;;
    3)
        create_socks_proxy
        ;;
    4)
        create_reverse_tunnel
        ;;
    5)
        list_tunnels
        ;;
    6)
        close_tunnel
        ;;
    0)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "Tips:"
echo "- Use -f flag to run tunnel in background"
echo "- Use -N flag to not execute remote commands"
echo "- Use -v flag for verbose output (debugging)"
echo "- Keep terminal open for foreground tunnels"
echo ""
