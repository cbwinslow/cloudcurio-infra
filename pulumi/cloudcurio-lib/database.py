"""
Database Stack Components
PostgreSQL, MySQL, Redis, and MongoDB infrastructure components
"""

import pulumi
from pulumi import ComponentResource, ResourceOptions
from typing import Optional, Dict


class DatabaseStackArgs:
    """Arguments for DatabaseStack component"""
    def __init__(
        self,
        postgres_enabled: bool = True,
        mysql_enabled: bool = False,
        redis_enabled: bool = True,
        mongodb_enabled: bool = False,
        postgres_version: str = "15",
        mysql_version: str = "8.0",
        redis_version: str = "7",
        mongodb_version: str = "6",
    ):
        self.postgres_enabled = postgres_enabled
        self.mysql_enabled = mysql_enabled
        self.redis_enabled = redis_enabled
        self.mongodb_enabled = mongodb_enabled
        self.postgres_version = postgres_version
        self.mysql_version = mysql_version
        self.redis_version = redis_version
        self.mongodb_version = mongodb_version


class DatabaseStack(ComponentResource):
    """
    Database Stack Component
    Deploys and manages database infrastructure
    """
    
    def __init__(
        self,
        name: str,
        args: DatabaseStackArgs,
        opts: Optional[ResourceOptions] = None
    ):
        super().__init__('cloudcurio:database:Stack', name, {}, opts)
        
        self.databases = {}
        
        if args.postgres_enabled:
            self.databases['postgres'] = {
                'port': 5432,
                'version': args.postgres_version,
            }
        
        if args.mysql_enabled:
            self.databases['mysql'] = {
                'port': 3306,
                'version': args.mysql_version,
            }
        
        if args.redis_enabled:
            self.databases['redis'] = {
                'port': 6379,
                'version': args.redis_version,
            }
        
        if args.mongodb_enabled:
            self.databases['mongodb'] = {
                'port': 27017,
                'version': args.mongodb_version,
            }
        
        # Export outputs
        self.register_outputs({
            'databases': self.databases,
            'postgres_enabled': args.postgres_enabled,
            'mysql_enabled': args.mysql_enabled,
            'redis_enabled': args.redis_enabled,
            'mongodb_enabled': args.mongodb_enabled,
        })
