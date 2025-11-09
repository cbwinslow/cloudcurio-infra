# Docker Compose Configurations

This directory contains Docker Compose configurations for deploying various software packages.

## Directory Structure

```
compose/
├── monitoring/          # Monitoring and network tools
├── analytics/           # Analytics and BI platforms
├── automation/          # Automation platforms
├── data/               # Data infrastructure (Kafka, Cassandra, etc.)
├── ai-ml/              # AI/ML platforms
├── dashboard/          # Dashboard applications
├── cms/                # Content management systems
├── security/           # Security tools
├── system/             # System utilities
└── ai-tools/           # AI development tools
```

## Quick Start

### Start a Single Service

```bash
# Start Zabbix
docker-compose -f monitoring/zabbix.yml up -d

# Start Metabase
docker-compose -f analytics/metabase.yml up -d

# Start Kafka
docker-compose -f data/kafka.yml up -d
```

### Stop a Service

```bash
docker-compose -f monitoring/zabbix.yml down
```

### View Logs

```bash
docker-compose -f monitoring/zabbix.yml logs -f
```

## Available Services

### Monitoring Tools

- **OpenNMS** (`monitoring/opennms.yml`) - Enterprise network monitoring
  - Access: http://localhost:8980/opennms
  - Credentials: admin/admin

- **Zabbix** (`monitoring/zabbix.yml`) - Complete monitoring solution
  - Access: http://localhost:8080
  - Credentials: Admin/zabbix

### Analytics & BI

- **PostHog** (`analytics/posthog.yml`) - Product analytics
  - Access: http://localhost:8000

- **Metabase** (`analytics/metabase.yml`) - Business intelligence
  - Access: http://localhost:3000

- **Plausible** (`analytics/plausible.yml`) - Privacy-friendly analytics
  - Access: http://localhost:8000

- **Umami** (`analytics/umami.yml`) - Simple analytics
  - Access: http://localhost:3000
  - Credentials: admin/umami

### Automation

- **StackStorm** (`automation/stackstorm.yml`) - Event-driven automation
  - Access: http://localhost (HTTPS)
  - Credentials: st2admin/Ch@ngeMe

### Data Infrastructure

- **Apache Kafka** (`data/kafka.yml`) - Event streaming
  - Broker: localhost:9092
  - UI: http://localhost:8080

- **Apache Cassandra** (`data/cassandra.yml`) - NoSQL database
  - CQL Port: 9042

### CMS & Frameworks

- **WordPress** (`cms/wordpress.yml`) - CMS
  - Access: http://localhost:8080
  - phpMyAdmin: http://localhost:8081

### Dashboards

- **Homepage** (`dashboard/homepage.yml`) - Application dashboard
  - Access: http://localhost:3000

### Security

- **Bitwarden** (`security/bitwarden.yml`) - Password manager
  - Access: http://localhost:8080

## Configuration

### Environment Variables

Most services use environment variables for configuration. You can:

1. Edit the compose file directly
2. Create a `.env` file in the same directory
3. Pass environment variables when starting:

```bash
docker-compose -f analytics/metabase.yml up -d \
  -e MB_DB_PASS=custom_password
```

### Volumes

All services use named volumes for data persistence. View volumes:

```bash
docker volume ls | grep servicename
```

### Networks

Each service creates its own network. To connect services, use Docker networks:

```bash
docker network create shared-network
```

## Common Operations

### Update Service

```bash
docker-compose -f monitoring/zabbix.yml pull
docker-compose -f monitoring/zabbix.yml up -d
```

### View Service Status

```bash
docker-compose -f monitoring/zabbix.yml ps
```

### Remove Service and Data

```bash
docker-compose -f monitoring/zabbix.yml down -v
```

### Backup Data

```bash
# Example: Backup PostgreSQL database
docker exec postgres-container pg_dump -U user dbname > backup.sql
```

## Troubleshooting

### Service won't start

1. Check logs: `docker-compose -f service.yml logs`
2. Verify ports aren't in use: `netstat -tulpn | grep PORT`
3. Check disk space: `df -h`
4. Verify Docker daemon: `systemctl status docker`

### Performance Issues

1. Increase resource limits in compose file:
```yaml
services:
  myservice:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
```

### Network Issues

1. Check network: `docker network inspect network-name`
2. Test connectivity: `docker exec container ping other-container`

## Best Practices

1. **Use named volumes** for data persistence
2. **Set resource limits** to prevent resource exhaustion
3. **Enable healthchecks** for better reliability
4. **Use environment files** for sensitive data
5. **Regular backups** of data volumes
6. **Monitor logs** for issues
7. **Update regularly** for security patches

## Security Considerations

1. **Change default passwords** immediately
2. **Use strong secrets** for encryption keys
3. **Enable TLS/SSL** for production
4. **Restrict network access** with firewall rules
5. **Regular security updates**
6. **Review logs** for suspicious activity

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [CloudCurio Software Catalog](../../SOFTWARE_CATALOG.md)
- [Installation Scripts](../../scripts/installers/)

## Support

For issues or questions:
- Check the SOFTWARE_CATALOG.md for detailed documentation
- Review logs: `docker-compose logs -f`
- GitHub Issues: [Report a problem](https://github.com/cbwinslow/cloudcurio-infra/issues)
