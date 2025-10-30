#!/bin/bash
# SSH tunnel helper script for bypassing network restrictions
set -e

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
    
    echo "Creating local port forward..."
    echo "Local port $local_port -> $remote_host:$remote_port via $ssh_server"
    
    ssh -f -N -L $local_port:$remote_host:$remote_port $ssh_server
    
    if [ $? -eq 0 ]; then
        echo "✓ Tunnel created successfully!"
        echo "You can now connect to localhost:$local_port"
    else
        echo "✗ Failed to create tunnel"
    fi
}

create_remote_forward() {
    read -p "Remote port: " remote_port
    read -p "Local host: " local_host
    read -p "Local port: " local_port
    read -p "SSH server (user@host): " ssh_server
    
    echo "Creating remote port forward..."
    echo "Remote port $remote_port -> $local_host:$local_port"
    
    ssh -f -N -R $remote_port:$local_host:$local_port $ssh_server
    
    if [ $? -eq 0 ]; then
        echo "✓ Tunnel created successfully!"
    else
        echo "✗ Failed to create tunnel"
    fi
}

create_socks_proxy() {
    read -p "SOCKS proxy port (default 8080): " socks_port
    socks_port=${socks_port:-8080}
    read -p "SSH server (user@host): " ssh_server
    
    echo "Creating SOCKS proxy on port $socks_port..."
    
    ssh -f -N -D $socks_port $ssh_server
    
    if [ $? -eq 0 ]; then
        echo "✓ SOCKS proxy created successfully!"
        echo "Configure your browser/application to use SOCKS5 proxy:"
        echo "  Host: localhost"
        echo "  Port: $socks_port"
    else
        echo "✗ Failed to create SOCKS proxy"
    fi
}

create_reverse_tunnel() {
    read -p "Remote port (for reverse connection): " remote_port
    read -p "SSH server (user@host): " ssh_server
    
    echo "Creating reverse SSH tunnel..."
    echo "Remote users can connect to $ssh_server:$remote_port to reach this machine"
    
    ssh -f -N -R $remote_port:localhost:22 $ssh_server
    
    if [ $? -eq 0 ]; then
        echo "✓ Reverse tunnel created successfully!"
        echo "From remote machine, connect with: ssh -p $remote_port user@localhost"
    else
        echo "✗ Failed to create reverse tunnel"
    fi
}

close_tunnel() {
    echo "Active tunnels:"
    ps aux | grep "ssh.*-[LRD]" | grep -v grep | nl
    
    read -p "Enter PID to close: " pid
    
    if [ -n "$pid" ]; then
        kill $pid 2>/dev/null && echo "✓ Tunnel closed" || echo "✗ Failed to close tunnel"
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
