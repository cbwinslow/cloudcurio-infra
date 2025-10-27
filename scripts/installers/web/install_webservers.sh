#!/bin/bash
# Web server stack installer (Apache, Nginx, or Caddy)
set -e

echo "Web Server Installer"
echo "===================="
echo "1) Apache"
echo "2) Nginx"
echo "3) Caddy"
echo "4) All (Apache + Nginx + Caddy)"
read -p "Choose web server [1-4]: " choice

case $choice in
    1)
        echo "Installing Apache..."
        sudo apt-get update
        sudo apt-get install -y apache2
        sudo systemctl enable apache2
        sudo systemctl start apache2
        sudo ufw allow 'Apache Full'
        echo "Apache installed! Access at http://localhost"
        ;;
    2)
        echo "Installing Nginx..."
        sudo apt-get update
        sudo apt-get install -y nginx
        sudo systemctl enable nginx
        sudo systemctl start nginx
        sudo ufw allow 'Nginx Full'
        echo "Nginx installed! Access at http://localhost"
        ;;
    3)
        echo "Installing Caddy..."
        sudo apt-get update
        sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl
        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" | sudo tee /etc/apt/sources.list.d/caddy.list
        sudo apt-get update
        sudo apt-get install -y caddy
        sudo systemctl enable caddy
        sudo systemctl start caddy
        sudo ufw allow 80,443/tcp
        echo "Caddy installed! Access at http://localhost"
        ;;
    4)
        echo "Installing all web servers..."
        # Apache
        sudo apt-get update
        sudo apt-get install -y apache2
        sudo systemctl enable apache2
        sudo systemctl stop apache2  # Stop to avoid port conflicts
        
        # Nginx
        sudo apt-get install -y nginx
        sudo systemctl enable nginx
        sudo systemctl stop nginx  # Stop to avoid port conflicts
        
        # Caddy
        sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl
        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" | sudo tee /etc/apt/sources.list.d/caddy.list
        sudo apt-get update
        sudo apt-get install -y caddy
        sudo systemctl enable caddy
        
        sudo ufw allow 80,443/tcp
        echo "All web servers installed!"
        echo "Note: Only one can run on ports 80/443 at a time."
        echo "Start the one you want: sudo systemctl start apache2|nginx|caddy"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo "Installation complete!"
