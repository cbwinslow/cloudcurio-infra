"""
ZeroTier Infrastructure Components
Manages ZeroTier networks and node configurations
"""

import pulumi
from pulumi import ComponentResource, ResourceOptions, Output
from typing import Dict, List, Optional


class ZeroTierNodeArgs:
    """Arguments for ZeroTierNode component"""
    def __init__(
        self,
        hostname: str,
        ip_address: str,
        description: Optional[str] = None,
        authorized: bool = True,
        tags: Optional[Dict[str, str]] = None
    ):
        self.hostname = hostname
        self.ip_address = ip_address
        self.description = description or f"ZeroTier node for {hostname}"
        self.authorized = authorized
        self.tags = tags or {}


class ZeroTierNode(ComponentResource):
    """
    ZeroTier Node Component
    Represents a node in the ZeroTier network with DNS and configuration
    """
    
    def __init__(
        self,
        name: str,
        args: ZeroTierNodeArgs,
        opts: Optional[ResourceOptions] = None
    ):
        super().__init__('cloudcurio:zerotier:Node', name, {}, opts)
        
        self.hostname = args.hostname
        self.ip_address = args.ip_address
        self.description = args.description
        
        # Export outputs
        self.register_outputs({
            'hostname': self.hostname,
            'ip_address': self.ip_address,
            'description': self.description,
        })


class ZeroTierNetworkArgs:
    """Arguments for ZeroTierNetwork component"""
    def __init__(
        self,
        network_id: str,
        network_name: str,
        nodes: List[ZeroTierNodeArgs],
        subnet: str = "172.28.0.0/16",
    ):
        self.network_id = network_id
        self.network_name = network_name
        self.nodes = nodes
        self.subnet = subnet


class ZeroTierNetwork(ComponentResource):
    """
    ZeroTier Network Component
    Manages a complete ZeroTier network with multiple nodes
    """
    
    def __init__(
        self,
        name: str,
        args: ZeroTierNetworkArgs,
        opts: Optional[ResourceOptions] = None
    ):
        super().__init__('cloudcurio:zerotier:Network', name, {}, opts)
        
        self.network_id = args.network_id
        self.network_name = args.network_name
        self.subnet = args.subnet
        
        # Create nodes
        self.nodes = []
        for node_args in args.nodes:
            node = ZeroTierNode(
                f"{name}-{node_args.hostname}",
                node_args,
                ResourceOptions(parent=self)
            )
            self.nodes.append(node)
        
        # Export outputs
        self.register_outputs({
            'network_id': self.network_id,
            'network_name': self.network_name,
            'subnet': self.subnet,
            'node_count': len(self.nodes),
        })
