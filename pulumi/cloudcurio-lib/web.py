"""
Web Server Stack Components
Caddy, Nginx, and Apache web server infrastructure
"""

import pulumi
from pulumi import ComponentResource, ResourceOptions
from typing import Optional, List, Dict


class WebServerStackArgs:
    """Arguments for WebServerStack component"""
    def __init__(
        self,
        server_type: str = "caddy",  # caddy, nginx, apache
        domains: Optional[List[str]] = None,
        ssl_enabled: bool = True,
        http_port: int = 80,
        https_port: int = 443,
    ):
        self.server_type = server_type
        self.domains = domains or []
        self.ssl_enabled = ssl_enabled
        self.http_port = http_port
        self.https_port = https_port


class WebServerStack(ComponentResource):
    """
    Web Server Stack Component
    Deploys web server infrastructure (Caddy, Nginx, or Apache)
    """
    
    def __init__(
        self,
        name: str,
        args: WebServerStackArgs,
        opts: Optional[ResourceOptions] = None
    ):
        super().__init__('cloudcurio:web:Stack', name, {}, opts)
        
        self.server_type = args.server_type
        self.domains = args.domains
        self.ssl_enabled = args.ssl_enabled
        
        # Configuration
        self.config = {
            'http_port': args.http_port,
            'https_port': args.https_port,
            'ssl_enabled': args.ssl_enabled,
        }
        
        # Export outputs
        self.register_outputs({
            'server_type': self.server_type,
            'domains': self.domains,
            'http_port': args.http_port,
            'https_port': args.https_port,
            'ssl_enabled': args.ssl_enabled,
        })
