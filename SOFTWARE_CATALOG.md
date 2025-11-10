# CloudCurio Software Catalog

This catalog provides a comprehensive overview of all available software installations, including installation methods, deployment options, and access information.

## Table of Contents

1. [Monitoring & Network Tools](#monitoring--network-tools)
2. [Automation Platforms](#automation-platforms)
3. [Analytics & Business Intelligence](#analytics--business-intelligence)
4. [AI/LLM Platforms](#aillm-platforms)
5. [Data Infrastructure](#data-infrastructure)
6. [AI Development Tools](#ai-development-tools)
7. [Gaming Servers](#gaming-servers)
8. [Dashboards & Homepages](#dashboards--homepages)
9. [Security & Password Management](#security--password-management)
10. [CMS & Web Frameworks](#cms--web-frameworks)
11. [Development Tools & LSPs](#development-tools--lsps)
12. [System & Statistics Tools](#system--statistics-tools)

## Installation Methods

Each software package can be installed using one or more of the following methods:

- **Bare Metal**: Direct installation scripts (`scripts/installers/`)
- **Docker Compose**: Container-based deployments (`docker/compose/`)
- **Ansible**: Automated playbooks (`roles/`)

---

## Monitoring & Network Tools

### OpenNMS
**Purpose**: Enterprise-grade network monitoring and management platform

**Installation Methods**:
- Bare Metal: `bash scripts/installers/monitoring/install_opennms.sh`
- Docker Compose: `docker-compose -f docker/compose/monitoring/opennms.yml up -d`
- Ansible: `ansible-playbook playbooks/install_opennms.yml`

**Default Access**: http://localhost:8980/opennms (admin/admin)

**Features**:
- Network discovery and monitoring
- Performance metrics collection
- Fault management
- Service assurance

---

### Zabbix
**Purpose**: Open-source monitoring solution for networks and applications

**Installation Methods**:
- Bare Metal: `bash scripts/installers/monitoring/install_zabbix.sh`
- Docker Compose: `docker-compose -f docker/compose/monitoring/zabbix.yml up -d`
- Ansible: `ansible-playbook playbooks/install_zabbix.yml`

**Default Access**: http://localhost:8080 (Admin/zabbix)

**Features**:
- Real-time monitoring
- Distributed monitoring
- Auto-discovery
- Flexible alerting

---

### Web Check
**Purpose**: Website availability and performance monitoring

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/monitoring/webcheck.yml up -d`
- Ansible: `ansible-playbook playbooks/install_webcheck.yml`

**Default Access**: http://localhost:3000

**Features**:
- SSL certificate monitoring
- DNS checks
- Performance metrics
- Uptime tracking

---

### Kibitzr
**Purpose**: Personal Web Assistant for monitoring and automation

**Installation Methods**:
- Bare Metal: `bash scripts/installers/automation/install_kibitzr.sh`
- Docker Compose: `docker-compose -f docker/compose/automation/kibitzr.yml up -d`

**Features**:
- Web page monitoring
- Content changes detection
- Custom notifications
- Scriptable automation

---

## Automation Platforms

### Leon
**Purpose**: Open-source personal assistant that runs on your server

**Installation Methods**:
- Bare Metal: `bash scripts/installers/automation/install_leon.sh`
- Docker Compose: `docker-compose -f docker/compose/automation/leon.yml up -d`
- Ansible: `ansible-playbook playbooks/install_leon.yml`

**Default Access**: http://localhost:1337

**Features**:
- Voice command support
- Modular architecture
- Privacy-focused (runs locally)
- Multi-language support

---

### Automatisch
**Purpose**: Open-source Zapier alternative for workflow automation

**Installation Methods**:
- Bare Metal: `bash scripts/installers/automation/install_automatisch.sh`
- Docker Compose: `docker-compose -f docker/compose/automation/automatisch.yml up -d`
- Ansible: `ansible-playbook playbooks/install_automatisch.yml`

**Default Access**: http://localhost:3000

**Features**:
- Visual workflow builder
- 100+ integrations
- Self-hosted
- REST API support

---

### StackStorm
**Purpose**: Event-driven automation platform (IFTTT for Ops)

**Installation Methods**:
- Bare Metal: `bash scripts/installers/automation/install_stackstorm.sh`
- Docker Compose: `docker-compose -f docker/compose/automation/stackstorm.yml up -d`
- Ansible: `ansible-playbook playbooks/install_stackstorm.yml`

**Default Access**: http://localhost:8080 (st2admin/Ch@ngeMe)

**Features**:
- Event-driven automation
- ChatOps integration
- 6000+ actions/integrations
- Workflow orchestration

---

### Eonza
**Purpose**: Lightweight automation software for task automation

**Installation Methods**:
- Bare Metal: `bash scripts/installers/automation/install_eonza.sh`
- Docker Compose: `docker-compose -f docker/compose/automation/eonza.yml up -d`

**Default Access**: http://localhost:3234

**Features**:
- Visual script builder
- Task scheduling
- File operations
- HTTP requests

---

## Analytics & Business Intelligence

### PostHog
**Purpose**: Product analytics platform with session recording

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/analytics/posthog.yml up -d`
- Ansible: `ansible-playbook playbooks/install_posthog.yml`

**Default Access**: http://localhost:8000

**Features**:
- Event tracking
- Session recording
- Feature flags
- A/B testing
- Heatmaps

---

### Plausible
**Purpose**: Privacy-friendly Google Analytics alternative

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/analytics/plausible.yml up -d`
- Ansible: `ansible-playbook playbooks/install_plausible.yml`

**Default Access**: http://localhost:8000

**Features**:
- Privacy-focused
- No cookies
- Lightweight script
- Real-time dashboard

---

### Metabase
**Purpose**: Open-source business intelligence and analytics

**Installation Methods**:
- Bare Metal: `bash scripts/installers/analytics/install_metabase.sh`
- Docker Compose: `docker-compose -f docker/compose/analytics/metabase.yml up -d`
- Ansible: `ansible-playbook playbooks/install_metabase.yml`

**Default Access**: http://localhost:3000

**Features**:
- Visual query builder
- Dashboard creation
- Multiple database support
- Scheduled reports

---

### Umami
**Purpose**: Simple, fast, privacy-focused alternative to Google Analytics

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/analytics/umami.yml up -d`
- Ansible: `ansible-playbook playbooks/install_umami.yml`

**Default Access**: http://localhost:3000 (admin/umami)

**Features**:
- Simple analytics
- Privacy-focused
- Lightweight
- Real-time stats

---

### Apache Superset
**Purpose**: Modern data exploration and visualization platform

**Installation Methods**:
- Bare Metal: `bash scripts/installers/analytics/install_superset.sh`
- Docker Compose: `docker-compose -f docker/compose/analytics/superset.yml up -d`
- Ansible: `ansible-playbook playbooks/install_superset.yml`

**Default Access**: http://localhost:8088 (admin/admin)

**Features**:
- Rich visualizations
- SQL IDE
- Semantic layer
- Lightweight and scalable

---

### Aptabase
**Purpose**: Open-source, privacy-first analytics for mobile and desktop apps

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/analytics/aptabase.yml up -d`

**Default Access**: http://localhost:3000

**Features**:
- Privacy-first
- Mobile and desktop analytics
- Self-hosted
- Simple integration

---

### Mixpost
**Purpose**: Self-hosted social media management platform

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/analytics/mixpost.yml up -d`
- Ansible: `ansible-playbook playbooks/install_mixpost.yml`

**Default Access**: http://localhost:8080

**Features**:
- Social media scheduling
- Analytics dashboard
- Multi-account support
- Content calendar

---

### Open Web Analytics
**Purpose**: Open-source web analytics framework

**Installation Methods**:
- Bare Metal: `bash scripts/installers/analytics/install_owa.sh`
- Docker Compose: `docker-compose -f docker/compose/analytics/owa.yml up -d`

**Default Access**: http://localhost:8080/owa

**Features**:
- Page tracking
- E-commerce tracking
- Campaign tracking
- WordPress plugin

---

## AI/LLM Platforms

### Langfuse
**Purpose**: Open-source LLM engineering platform (already installed)

**Installation Methods**:
- Existing: Part of AI stack
- Docker Compose: `docker-compose -f docker/compose/ai-ml/langfuse.yml up -d`

**Default Access**: http://localhost:3000

---

### Langsmith
**Purpose**: LangChain debugging and monitoring platform

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/ai-ml/langsmith.yml up -d`
- Ansible: `ansible-playbook playbooks/install_langsmith.yml`

**Default Access**: http://localhost:8000

**Features**:
- LLM application debugging
- Trace visualization
- Dataset management
- Testing and evaluation

---

### LangChain
**Purpose**: Framework for developing LLM applications (library)

**Installation Methods**:
- Bare Metal: `bash scripts/installers/ai-ml/install_langchain.sh`

**Note**: LangChain is a Python/TypeScript library, not a standalone service

---

### LangGraph
**Purpose**: Library for building stateful multi-actor applications with LLMs

**Installation Methods**:
- Bare Metal: `bash scripts/installers/ai-ml/install_langgraph.sh`

**Note**: LangGraph is a library extension for LangChain

---

## Data Infrastructure

### Apache Kafka
**Purpose**: Distributed event streaming platform

**Installation Methods**:
- Bare Metal: `bash scripts/installers/data/install_kafka.sh`
- Docker Compose: `docker-compose -f docker/compose/data/kafka.yml up -d`
- Ansible: `ansible-playbook playbooks/install_kafka.yml`

**Default Access**: localhost:9092

**Features**:
- High throughput messaging
- Scalable pub/sub
- Stream processing
- Durable storage

---

### Apache Cassandra
**Purpose**: Distributed NoSQL database

**Installation Methods**:
- Bare Metal: `bash scripts/installers/data/install_cassandra.sh`
- Docker Compose: `docker-compose -f docker/compose/data/cassandra.yml up -d`
- Ansible: `ansible-playbook playbooks/install_cassandra.yml`

**Default Access**: localhost:9042

**Features**:
- High availability
- Linear scalability
- No single point of failure
- Multi-datacenter replication

---

### RudderStack
**Purpose**: Customer data platform (CDP) for collecting and routing data

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/data/rudderstack.yml up -d`
- Ansible: `ansible-playbook playbooks/install_rudderstack.yml`

**Default Access**: http://localhost:8080

**Features**:
- Event streaming
- Data warehouse sync
- Customer data unification
- Privacy controls

---

### Kilde
**Purpose**: Open-source data integration platform

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/data/kilde.yml up -d`

**Default Access**: http://localhost:8080

---

### Parseable
**Purpose**: Cloud-native log analytics platform

**Installation Methods**:
- Bare Metal: `bash scripts/installers/data/install_parseable.sh`
- Docker Compose: `docker-compose -f docker/compose/data/parseable.yml up -d`

**Default Access**: http://localhost:8000

**Features**:
- Log aggregation
- Real-time queries
- S3-compatible storage
- Low resource usage

---

## AI Development Tools

### AI Scraper
**Purpose**: AI-powered web scraping tool

**Installation Methods**:
- Bare Metal: `bash scripts/installers/ai-ml/install_aiscraper.sh`
- Docker Compose: `docker-compose -f docker/compose/ai-ml/aiscraper.yml up -d`

**Features**:
- Intelligent content extraction
- Structured data output
- API support

---

### AI Quant
**Purpose**: AI-powered quantitative trading platform

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/ai-ml/aiquant.yml up -d`

**Default Access**: http://localhost:8080

---

### Matchering
**Purpose**: AI-powered audio mastering

**Installation Methods**:
- Bare Metal: `bash scripts/installers/ai-ml/install_matchering.sh`
- Docker Compose: `docker-compose -f docker/compose/ai-ml/matchering.yml up -d`

**Default Access**: http://localhost:8000

**Features**:
- Automated audio mastering
- Reference matching
- Batch processing

---

## Gaming Servers

### LinuxGSM
**Purpose**: Command-line tool for deploying and managing game servers

**Installation Methods**:
- Bare Metal: `bash scripts/installers/gaming/install_linuxgsm.sh`

**Features**:
- 120+ game server support
- Automated updates
- Backup management
- Server monitoring

**Supported Games**: CS:GO, Minecraft, ARK, Rust, Team Fortress 2, and many more

---

## Dashboards & Homepages

### Homepage
**Purpose**: Modern, customizable application dashboard

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/dashboard/homepage.yml up -d`
- Ansible: `ansible-playbook playbooks/install_homepage.yml`

**Default Access**: http://localhost:3000

**Features**:
- Service integration
- Docker integration
- Customizable widgets
- Multiple themes

---

### OliveTin
**Purpose**: Web UI for running Linux shell commands

**Installation Methods**:
- Bare Metal: `bash scripts/installers/system/install_olivetin.sh`
- Docker Compose: `docker-compose -f docker/compose/system/olivetin.yml up -d`
- Ansible: `ansible-playbook playbooks/install_olivetin.yml`

**Default Access**: http://localhost:1337

**Features**:
- Safe command execution
- Custom buttons
- Argument inputs
- Access control

---

## Security & Password Management

### Bitwarden (Self-hosted)
**Purpose**: Open-source password manager

**Installation Methods**:
- Bare Metal: `bash scripts/installers/security/install_bitwarden.sh`
- Docker Compose: `docker-compose -f docker/compose/security/bitwarden.yml up -d`
- Ansible: `ansible-playbook playbooks/install_bitwarden.yml`

**Default Access**: http://localhost:8080

**Features**:
- End-to-end encryption
- Cross-platform
- Secure sharing
- 2FA support

---

## CMS & Web Frameworks

### WordPress CMS
**Purpose**: Most popular content management system

**Installation Methods**:
- Bare Metal: `bash scripts/installers/cms/install_wordpress.sh`
- Docker Compose: `docker-compose -f docker/compose/cms/wordpress.yml up -d`
- Ansible: `ansible-playbook playbooks/install_wordpress.yml`

**Default Access**: http://localhost:8080

---

### Ghost
**Purpose**: Modern headless CMS for blogs

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/cms/ghost.yml up -d`
- Ansible: `ansible-playbook playbooks/install_ghost.yml`

**Default Access**: http://localhost:2368

---

### Hugo
**Purpose**: Fast static site generator

**Installation Methods**:
- Bare Metal: `bash scripts/installers/cms/install_hugo.sh`

---

### Next.js Framework
**Purpose**: React framework for production

**Installation Methods**:
- Bare Metal: `bash scripts/installers/frameworks/install_nextjs.sh`

---

### Astro Framework
**Purpose**: Modern static site builder

**Installation Methods**:
- Bare Metal: `bash scripts/installers/frameworks/install_astro.sh`

---

## Development Tools & LSPs

### TypeScript LSP
**Purpose**: TypeScript language server

**Installation Methods**:
- Bare Metal: `bash scripts/installers/development/install_typescript_lsp.sh`

---

### Python LSP (Pylsp)
**Purpose**: Python language server

**Installation Methods**:
- Bare Metal: `bash scripts/installers/development/install_python_lsp.sh`

---

### Aider (Already Installed)
**Purpose**: AI pair programming tool

**Installation Methods**:
- Existing role: `roles/development/aider`

---

### Codex CLI
**Purpose**: OpenAI Codex command-line tool

**Installation Methods**:
- Bare Metal: `bash scripts/installers/ai-tools/install_codex_cli.sh`

---

### Qwen-Code
**Purpose**: Alibaba's code generation model

**Installation Methods**:
- Docker Compose: `docker-compose -f docker/compose/ai-tools/qwen-code.yml up -d`

---

### Crush
**Purpose**: Terminal-based code assistant

**Installation Methods**:
- Bare Metal: `bash scripts/installers/ai-tools/install_crush.sh`

---

### Gemini CLI
**Purpose**: Google Gemini CLI tool

**Installation Methods**:
- Bare Metal: `bash scripts/installers/ai-tools/install_gemini_cli.sh`

---

### Cline
**Purpose**: AI coding assistant

**Installation Methods**:
- Bare Metal: `bash scripts/installers/ai-tools/install_cline.sh`

---

### Kimi CLI
**Purpose**: Moonshot AI CLI tool

**Installation Methods**:
- Bare Metal: `bash scripts/installers/ai-tools/install_kimi_cli.sh`

---

## System & Statistics Tools

### vstat
**Purpose**: Virtual memory statistics

**Installation Methods**:
- Bare Metal: `bash scripts/installers/system/install_vstat.sh`

---

### vtstat
**Purpose**: Terminal statistics display

**Installation Methods**:
- Bare Metal: `bash scripts/installers/system/install_vtstat.sh`

---

### statpak
**Purpose**: System statistics package

**Installation Methods**:
- Bare Metal: `bash scripts/installers/system/install_statpak.sh`

---

## Quick Start Commands

### Install Everything
```bash
# Run master installer (interactive)
bash scripts/installers/master_software_installer.sh

# Or use Ansible for full deployment
ansible-playbook playbooks/install_all_software.yml
```

### Install by Category
```bash
# Monitoring tools
bash scripts/installers/monitoring/install_all_monitoring.sh

# Analytics tools
bash scripts/installers/analytics/install_all_analytics.sh

# AI/ML tools
bash scripts/installers/ai-ml/install_all_ai_tools.sh

# Automation platforms
bash scripts/installers/automation/install_all_automation.sh
```

### Docker Compose Stacks
```bash
# Start all monitoring services
docker-compose -f docker/compose/monitoring-stack.yml up -d

# Start all analytics services
docker-compose -f docker/compose/analytics-stack.yml up -d

# Start all AI/ML services
docker-compose -f docker/compose/ai-ml-stack.yml up -d
```

---

## Support and Documentation

For more detailed installation instructions, configuration options, and troubleshooting:

- **Installation Guide**: [SETUP_GUIDE.md](SETUP_GUIDE.md)
- **Quick Start**: [QUICKSTART.md](QUICKSTART.md)
- **Infrastructure Guide**: [INFRASTRUCTURE_GUIDE.md](INFRASTRUCTURE_GUIDE.md)
- **Testing**: [TESTING_GUIDE.md](TESTING_GUIDE.md)

## License

All software listed is subject to their respective licenses. Please review individual project licenses before deployment.
