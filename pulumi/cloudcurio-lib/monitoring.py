"""
Monitoring Stack Components
Prometheus, Grafana, and Loki infrastructure components
"""

import pulumi
from pulumi import ComponentResource, ResourceOptions, Output
from typing import Dict, List, Optional


class MonitoringStackArgs:
    """Arguments for MonitoringStack component"""
    def __init__(
        self,
        prometheus_enabled: bool = True,
        grafana_enabled: bool = True,
        loki_enabled: bool = True,
        retention_days: int = 90,
        scrape_interval: str = "15s",
        targets: Optional[List[str]] = None,
    ):
        self.prometheus_enabled = prometheus_enabled
        self.grafana_enabled = grafana_enabled
        self.loki_enabled = loki_enabled
        self.retention_days = retention_days
        self.scrape_interval = scrape_interval
        self.targets = targets or []


class MonitoringStack(ComponentResource):
    """
    Monitoring Stack Component
    Deploys Prometheus, Grafana, and Loki monitoring infrastructure
    """
    
    def __init__(
        self,
        name: str,
        args: MonitoringStackArgs,
        opts: Optional[ResourceOptions] = None
    ):
        super().__init__('cloudcurio:monitoring:Stack', name, {}, opts)
        
        self.prometheus_enabled = args.prometheus_enabled
        self.grafana_enabled = args.grafana_enabled
        self.loki_enabled = args.loki_enabled
        
        # Configuration
        self.config = {
            'retention_days': args.retention_days,
            'scrape_interval': args.scrape_interval,
            'targets': args.targets,
        }
        
        # Export outputs
        self.register_outputs({
            'prometheus_enabled': self.prometheus_enabled,
            'grafana_enabled': self.grafana_enabled,
            'loki_enabled': self.loki_enabled,
            'prometheus_port': 9090,
            'grafana_port': 3000,
            'loki_port': 3100,
        })


class PrometheusConfig:
    """Helper class for Prometheus configuration generation"""
    
    @staticmethod
    def generate_config(
        scrape_interval: str,
        targets: List[str],
        retention_days: int
    ) -> Dict:
        """Generate Prometheus configuration"""
        return {
            'global': {
                'scrape_interval': scrape_interval,
                'evaluation_interval': scrape_interval,
            },
            'scrape_configs': [
                {
                    'job_name': 'prometheus',
                    'static_configs': [{'targets': ['localhost:9090']}]
                },
                {
                    'job_name': 'node-exporters',
                    'static_configs': [{'targets': [f"{t}:9100" for t in targets]}]
                }
            ]
        }
