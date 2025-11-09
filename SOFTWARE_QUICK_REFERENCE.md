# Software Quick Reference Guide

Quick access commands for all 55+ software installations.

## Monitoring Tools

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **OpenNMS** | `sudo bash scripts/installers/monitoring/install_opennms.sh` | `docker-compose -f docker/compose/monitoring/opennms.yml up -d` | http://localhost:8980/opennms (admin/admin) |
| **Zabbix** | `sudo bash scripts/installers/monitoring/install_zabbix.sh` | `docker-compose -f docker/compose/monitoring/zabbix.yml up -d` | http://localhost:8080 (Admin/zabbix) |
| **Web Check** | N/A | `docker-compose -f docker/compose/monitoring/webcheck.yml up -d` | http://localhost:3000 |

## Automation Platforms

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **Leon** | `sudo bash scripts/installers/automation/install_leon.sh` | `docker-compose -f docker/compose/automation/leon.yml up -d` | http://localhost:1337 |
| **Automatisch** | `sudo bash scripts/installers/automation/install_automatisch.sh` | `docker-compose -f docker/compose/automation/automatisch.yml up -d` | http://localhost:3000 |
| **StackStorm** | N/A | `docker-compose -f docker/compose/automation/stackstorm.yml up -d` | https://localhost (st2admin/Ch@ngeMe) |
| **Eonza** | `sudo bash scripts/installers/automation/install_eonza.sh` | N/A | http://localhost:3234 |
| **Kibitzr** | `sudo bash scripts/installers/automation/install_kibitzr.sh` | `docker-compose -f docker/compose/automation/kibitzr.yml up -d` | CLI Tool |

## Analytics & BI Tools

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **PostHog** | N/A | `docker-compose -f docker/compose/analytics/posthog.yml up -d` | http://localhost:8000 |
| **Plausible** | N/A | `docker-compose -f docker/compose/analytics/plausible.yml up -d` | http://localhost:8000 |
| **Metabase** | `sudo bash scripts/installers/analytics/install_metabase.sh` | `docker-compose -f docker/compose/analytics/metabase.yml up -d` | http://localhost:3000 |
| **Umami** | N/A | `docker-compose -f docker/compose/analytics/umami.yml up -d` | http://localhost:3000 (admin/umami) |
| **Apache Superset** | `sudo bash scripts/installers/analytics/install_superset.sh` | `docker-compose -f docker/compose/analytics/superset.yml up -d` | http://localhost:8088 (admin/admin) |
| **Aptabase** | N/A | `docker-compose -f docker/compose/analytics/aptabase.yml up -d` | http://localhost:3000 |
| **Mixpost** | N/A | `docker-compose -f docker/compose/analytics/mixpost.yml up -d` | http://localhost:8080 |
| **Open Web Analytics** | `sudo bash scripts/installers/analytics/install_owa.sh` | `docker-compose -f docker/compose/analytics/owa.yml up -d` | http://localhost:8080/owa |

## Data Infrastructure

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **Apache Kafka** | `sudo bash scripts/installers/data/install_kafka.sh` | `docker-compose -f docker/compose/data/kafka.yml up -d` | localhost:9092, UI: http://localhost:8080 |
| **Apache Cassandra** | `sudo bash scripts/installers/data/install_cassandra.sh` | `docker-compose -f docker/compose/data/cassandra.yml up -d` | CQL: localhost:9042 |
| **RudderStack** | N/A | `docker-compose -f docker/compose/data/rudderstack.yml up -d` | http://localhost:8080 |
| **Parseable** | `sudo bash scripts/installers/data/install_parseable.sh` | N/A | http://localhost:8000 |

## AI/ML Platforms

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **LangChain** | `bash scripts/installers/ai-ml/install_langchain.sh` | N/A | Python Library |
| **LangGraph** | `bash scripts/installers/ai-ml/install_langgraph.sh` | N/A | Python Library |
| **LangSmith** | N/A | `docker-compose -f docker/compose/ai-ml/langsmith.yml up -d` | http://localhost:8000 |
| **Matchering** | `sudo bash scripts/installers/ai-ml/install_matchering.sh` | `docker-compose -f docker/compose/ai-ml/matchering.yml up -d` | http://localhost:8000 |
| **Langfuse** | Via AI Stack | See existing roles | http://localhost:3000 |

## Gaming

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **LinuxGSM** | `sudo bash scripts/installers/gaming/install_linuxgsm.sh` | N/A | CLI Tool |

## Dashboards

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **Homepage** | N/A | `docker-compose -f docker/compose/dashboard/homepage.yml up -d` | http://localhost:3000 |
| **OliveTin** | `sudo bash scripts/installers/system/install_olivetin.sh` | `docker-compose -f docker/compose/system/olivetin.yml up -d` | http://localhost:1337 |

## Security

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **Bitwarden** | N/A | `docker-compose -f docker/compose/security/bitwarden.yml up -d` | http://localhost:8080 |

## CMS & Frameworks

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **WordPress** | N/A | `docker-compose -f docker/compose/cms/wordpress.yml up -d` | http://localhost:8080 |
| **Ghost** | N/A | `docker-compose -f docker/compose/cms/ghost.yml up -d` | http://localhost:2368 |
| **Hugo** | `sudo bash scripts/installers/cms/install_hugo.sh` | N/A | CLI Tool |
| **Next.js** | `bash scripts/installers/frameworks/install_nextjs.sh` | N/A | CLI Tool |
| **Astro** | `bash scripts/installers/frameworks/install_astro.sh` | N/A | CLI Tool |

## Development Tools

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **TypeScript LSP** | `sudo bash scripts/installers/development/install_typescript_lsp.sh` | N/A | CLI Tool |
| **Python LSP** | `sudo bash scripts/installers/development/install_python_lsp.sh` | N/A | CLI Tool |

## AI Development Tools

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **Gemini CLI** | `bash scripts/installers/ai-tools/install_gemini_cli.sh` | N/A | CLI Tool |
| **Cline** | `bash scripts/installers/ai-tools/install_cline.sh` | N/A | CLI Tool |
| **Codex CLI** | `bash scripts/installers/ai-tools/install_codex_cli.sh` | N/A | CLI Tool |
| **Kimi CLI** | `bash scripts/installers/ai-tools/install_kimi_cli.sh` | N/A | CLI Tool |
| **Crush** | `bash scripts/installers/ai-tools/install_crush.sh` | N/A | CLI Tool |

## System Tools

| Software | Bare Metal | Docker Compose | Access |
|----------|------------|----------------|--------|
| **vstat** | `bash scripts/installers/system/install_vstat.sh` | N/A | CLI Tool |
| **vtstat** | `bash scripts/installers/system/install_vtstat.sh` | N/A | CLI Tool |
| **statpak** | `bash scripts/installers/system/install_statpak.sh` | N/A | CLI Tools |

---

## Master Installation Commands

### Interactive Installer (All Categories)
```bash
sudo bash scripts/installers/master_software_installer.sh
```

### Ansible Playbooks
```bash
# Install everything
ansible-playbook -i inventory/hosts.ini playbooks/install_all_software.yml

# Specific categories
ansible-playbook -i inventory/hosts.ini playbooks/install_monitoring_tools.yml
ansible-playbook -i inventory/hosts.ini playbooks/install_automation_tools.yml
```

---

## Quick Docker Commands

### Start Services
```bash
docker-compose -f docker/compose/CATEGORY/service.yml up -d
```

### Stop Services
```bash
docker-compose -f docker/compose/CATEGORY/service.yml down
```

### View Logs
```bash
docker-compose -f docker/compose/CATEGORY/service.yml logs -f
```

### Restart Services
```bash
docker-compose -f docker/compose/CATEGORY/service.yml restart
```

---

## Quick Systemd Commands

### Check Status
```bash
sudo systemctl status SERVICE_NAME
```

### Start/Stop/Restart
```bash
sudo systemctl start SERVICE_NAME
sudo systemctl stop SERVICE_NAME
sudo systemctl restart SERVICE_NAME
```

### View Logs
```bash
sudo journalctl -u SERVICE_NAME -f
```

---

## Default Ports Reference

| Service | Port | Protocol |
|---------|------|----------|
| OpenNMS | 8980 | HTTP |
| Zabbix | 8080 | HTTP |
| Leon | 1337 | HTTP |
| Automatisch | 3000 | HTTP |
| StackStorm | 443 | HTTPS |
| Metabase | 3000 | HTTP |
| Superset | 8088 | HTTP |
| PostHog | 8000 | HTTP |
| Kafka | 9092 | TCP |
| Kafka UI | 8080 | HTTP |
| Cassandra | 9042 | CQL |
| WordPress | 8080 | HTTP |
| Ghost | 2368 | HTTP |
| Homepage | 3000 | HTTP |
| OliveTin | 1337 | HTTP |
| Bitwarden | 8080 | HTTP |

---

## Environment Variables

Common environment variables needed for various services:

```bash
# API Keys
export OPENAI_API_KEY="your-key"
export GEMINI_API_KEY="your-key"
export LANGCHAIN_API_KEY="your-key"

# Database URLs
export DATABASE_URL="postgresql://user:pass@host:5432/db"

# Application Secrets
export SECRET_KEY="your-random-secret-key"
export APP_SECRET="your-random-secret"
```

---

## Backup & Restore

### Docker Volumes
```bash
# Backup volume
docker run --rm -v VOLUME_NAME:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz /data

# Restore volume
docker run --rm -v VOLUME_NAME:/data -v $(pwd):/backup alpine tar xzf /backup/backup.tar.gz -C /
```

### Database Backups
```bash
# PostgreSQL
docker exec CONTAINER_NAME pg_dump -U user database > backup.sql

# MySQL
docker exec CONTAINER_NAME mysqldump -u user -p database > backup.sql

# MongoDB
docker exec CONTAINER_NAME mongodump --out /backup
```

---

## Additional Resources

- **Full Documentation**: [SOFTWARE_CATALOG.md](SOFTWARE_CATALOG.md)
- **Installation Guide**: [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)
- **Docker Compose Guide**: [docker/compose/README.md](docker/compose/README.md)
- **Quick Start**: [QUICKSTART.md](QUICKSTART.md)
- **Infrastructure Guide**: [INFRASTRUCTURE_GUIDE.md](INFRASTRUCTURE_GUIDE.md)

---

## Support

For issues or questions:
- Check the [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md) troubleshooting section
- Review logs in `/tmp/*_install_*.log`
- GitHub Issues: [Report a problem](https://github.com/cbwinslow/cloudcurio-infra/issues)
