# DevOps Tools Reference

This document provides a comprehensive reference for all DevOps tools supported by CloudCurio Infrastructure. Tools are organized by category for easy navigation.

## Table of Contents

- [CI/CD & Automation](#cicd--automation)
- [Container & Orchestration](#container--orchestration)
- [Monitoring & Observability](#monitoring--observability)
- [Infrastructure as Code](#infrastructure-as-code)
- [Security & Compliance](#security--compliance)
- [Version Control & Collaboration](#version-control--collaboration)
- [Database & Storage](#database--storage)
- [Web Servers & Proxies](#web-servers--proxies)
- [Cloud Platforms](#cloud-platforms)
- [Development Tools](#development-tools)
- [Configuration Management](#configuration-management)
- [Logging & Analytics](#logging--analytics)
- [Networking Tools](#networking-tools)
- [Testing & Quality Assurance](#testing--quality-assurance)
- [Service Mesh](#service-mesh)

---

## CI/CD & Automation

### Jenkins
**Description**: Leading open-source automation server for CI/CD pipelines  
**Key Features**: Pipeline as code, extensive plugin ecosystem, distributed builds  
**Role**: `roles/jenkins`

### GitLab CI
**Description**: Complete DevOps platform with built-in CI/CD  
**Key Features**: Auto DevOps, container registry, Kubernetes integration  
**Role**: `roles/gitlab-ci`

### GitHub Actions
**Description**: GitHub's native CI/CD and automation platform  
**Key Features**: Workflow automation, marketplace actions, cloud or self-hosted  
**Role**: `roles/github-actions-runner`

### CircleCI
**Description**: Modern CI/CD platform with Docker-first approach  
**Key Features**: Parallel execution, SSH debugging, orbs reusable config  
**Role**: `roles/circleci-runner`

### Travis CI
**Description**: CI service integrated with GitHub  
**Key Features**: Multi-language support, matrix builds, deployment integrations  
**Role**: `roles/travis-ci`

### Drone CI
**Description**: Container-native CI/CD platform  
**Key Features**: Pipeline as code, Docker-based builds, plugin system  
**Role**: `roles/drone`

### TeamCity
**Description**: Powerful CI/CD server by JetBrains  
**Key Features**: Build chains, parallel testing, VCS integrations  
**Role**: `roles/teamcity`

### Bamboo
**Description**: Atlassian's CI/CD server  
**Key Features**: Jira integration, deployment projects, elastic agents  
**Role**: `roles/bamboo`

### Buildkite
**Description**: Fast and secure CI/CD platform  
**Key Features**: Hybrid architecture, unlimited parallelism, simple pipelines  
**Role**: `roles/buildkite-agent`

### GoCD
**Description**: Open-source continuous delivery server  
**Key Features**: Value stream modeling, dependency management, pipeline visualization  
**Role`: `roles/gocd`

### Spinnaker
**Description**: Multi-cloud continuous delivery platform  
**Key Features**: Multi-cloud deployments, advanced deployment strategies  
**Role**: `roles/spinnaker`

### Argo CD
**Description**: Declarative GitOps continuous delivery for Kubernetes  
**Key Features**: GitOps workflow, automated sync, rollback capabilities  
**Role**: `roles/argocd`

### Flux CD
**Description**: GitOps toolkit for Kubernetes  
**Key Features**: GitOps automation, progressive delivery, multi-tenancy  
**Role**: `roles/fluxcd`

### Tekton
**Description**: Cloud-native CI/CD framework for Kubernetes  
**Key Features**: Kubernetes-native, reusable pipelines, extensible  
**Role**: `roles/tekton`

---

## Container & Orchestration

### Docker
**Description**: Leading containerization platform  
**Key Features**: Container runtime, image building, Docker Hub  
**Role**: `roles/docker`

### Kubernetes
**Description**: Container orchestration platform  
**Key Features**: Auto-scaling, self-healing, service discovery  
**Role**: `roles/kubernetes`

### Podman
**Description**: Daemonless container engine  
**Key Features**: Rootless containers, Docker compatible, systemd integration  
**Role**: `roles/podman`

### containerd
**Description**: Industry-standard container runtime  
**Key Features**: Lightweight, simple, portable  
**Role**: `roles/containerd`

### CRI-O
**Description**: Lightweight container runtime for Kubernetes  
**Key Features**: OCI compliant, Kubernetes optimized  
**Role**: `roles/crio`

### Docker Swarm
**Description**: Native Docker clustering  
**Key Features**: Easy setup, integrated with Docker, service discovery  
**Role**: `roles/docker-swarm`

### Nomad
**Description**: Simple and flexible workload orchestrator  
**Key Features**: Multi-workload support, simple operations, cloud agnostic  
**Role**: `roles/nomad`

### OpenShift
**Description**: Enterprise Kubernetes platform by Red Hat  
**Key Features**: Developer tools, security features, hybrid cloud  
**Role**: `roles/openshift`

### Rancher
**Description**: Complete Kubernetes management platform  
**Key Features**: Multi-cluster management, centralized auth, built-in monitoring  
**Role**: `roles/rancher`

### K3s
**Description**: Lightweight Kubernetes distribution  
**Key Features**: Small footprint, edge computing, easy installation  
**Role**: `roles/k3s`

### MicroK8s
**Description**: Minimal Kubernetes for developers  
**Key Features**: Single-node cluster, snap package, quick setup  
**Role**: `roles/microk8s`

### Helm
**Description**: Package manager for Kubernetes  
**Key Features**: Charts, templating, release management  
**Role**: `roles/helm`

---

## Monitoring & Observability

### Prometheus
**Description**: Open-source monitoring and alerting toolkit  
**Key Features**: Time-series database, PromQL, service discovery  
**Role**: `roles/prometheus`

### Grafana
**Description**: Analytics and monitoring platform  
**Key Features**: Rich visualizations, multiple data sources, alerting  
**Role**: `roles/grafana`

### Nagios
**Description**: Infrastructure monitoring solution  
**Key Features**: Comprehensive monitoring, alerting, reporting  
**Role**: `roles/nagios`

### Zabbix
**Description**: Enterprise-class monitoring solution  
**Key Features**: Network monitoring, auto-discovery, templates  
**Role**: `roles/zabbix`

### Datadog
**Description**: Cloud-scale monitoring and analytics  
**Key Features**: APM, log management, infrastructure monitoring  
**Role**: `roles/datadog-agent`

### New Relic
**Description**: Full-stack observability platform  
**Key Features**: APM, infrastructure monitoring, synthetics  
**Role**: `roles/newrelic-agent`

### AppDynamics
**Description**: Application performance monitoring  
**Key Features**: Business transaction monitoring, code-level diagnostics  
**Role**: `roles/appdynamics-agent`

### Dynatrace
**Description**: Software intelligence platform  
**Key Features**: AI-powered monitoring, full-stack observability  
**Role**: `roles/dynatrace-agent`

### Sensu
**Description**: Monitoring for today's infrastructure  
**Key Features**: Multi-cloud monitoring, auto-remediation  
**Role`: `roles/sensu`

### Victoria Metrics
**Description**: Fast and cost-effective time-series database  
**Key Features**: Prometheus compatible, high performance, long-term storage  
**Role**: `roles/victoria-metrics`

### Thanos
**Description**: Highly available Prometheus setup  
**Key Features**: Long-term storage, global query view, downsampling  
**Role**: `roles/thanos`

### Cortex
**Description**: Horizontally scalable Prometheus  
**Key Features**: Multi-tenant, long-term storage, high availability  
**Role**: `roles/cortex`

### OpenTelemetry
**Description**: Observability framework for cloud-native software  
**Key Features**: Vendor-neutral, tracing, metrics, logs  
**Role**: `roles/opentelemetry-collector`

### Jaeger
**Description**: Distributed tracing system  
**Key Features**: OpenTracing compatible, root cause analysis, performance optimization  
**Role**: `roles/jaeger`

### Zipkin
**Description**: Distributed tracing system  
**Key Features**: Trace collection, latency analysis, dependency analysis  
**Role**: `roles/zipkin`

---

## Infrastructure as Code

### Terraform
**Description**: Infrastructure provisioning tool  
**Key Features**: Multi-cloud, declarative, state management  
**Role**: `roles/terraform`

### Ansible
**Description**: IT automation tool  
**Key Features**: Agentless, YAML syntax, extensive modules  
**Role**: Built-in

### Packer
**Description**: Machine image builder  
**Key Features**: Multi-platform, automated builds, cloud images  
**Role**: `roles/packer`

### Vagrant
**Description**: Development environment management  
**Key Features**: Portable environments, multi-provider, reproducible  
**Role**: `roles/vagrant`

### Pulumi
**Description**: Modern infrastructure as code  
**Key Features**: Use familiar languages, multi-cloud, state management  
**Role**: `roles/pulumi`

### CloudFormation
**Description**: AWS infrastructure as code  
**Key Features**: AWS native, stack management, drift detection  
**Role**: `roles/aws-cloudformation`

### CDK (Cloud Development Kit)
**Description**: Define cloud infrastructure using programming languages  
**Key Features**: AWS, Azure, Kubernetes support, type safety  
**Role**: `roles/aws-cdk`

### Crossplane
**Description**: Universal control plane for cloud infrastructure  
**Key Features**: Kubernetes-native, multi-cloud, composable  
**Role**: `roles/crossplane`

---

## Security & Compliance

### HashiCorp Vault
**Description**: Secrets management solution  
**Key Features**: Secret storage, dynamic secrets, encryption as a service  
**Role**: `roles/vault`

### SonarQube
**Description**: Code quality and security analysis  
**Key Features**: Static analysis, code coverage, security hotspots  
**Role**: `roles/sonarqube`

### Trivy
**Description**: Vulnerability scanner for containers  
**Key Features**: OS packages, application dependencies, IaC scanning  
**Role**: `roles/trivy`

### Clair
**Description**: Container vulnerability analysis  
**Key Features**: Static analysis, CVE database, API-driven  
**Role`: `roles/clair`

### Anchore
**Description**: Container security and compliance  
**Key Features**: Policy-based analysis, CVE scanning, compliance checks  
**Role**: `roles/anchore`

### Falco
**Description**: Cloud-native runtime security  
**Key Features**: Threat detection, syscall monitoring, Kubernetes audit  
**Role**: `roles/falco`

### OWASP ZAP
**Description**: Web application security scanner  
**Key Features**: Automated scanning, penetration testing, API security  
**Role**: `roles/owasp-zap`

### Snyk
**Description**: Developer security platform  
**Key Features**: Vulnerability scanning, container security, IaC scanning  
**Role**: `roles/snyk`

### Aqua Security
**Description**: Cloud-native security platform  
**Key Features**: Container security, serverless security, compliance  
**Role**: `roles/aqua-security`

### Twistlock (Prisma Cloud)
**Description**: Cloud-native security platform  
**Key Features**: Runtime protection, vulnerability management, compliance  
**Role**: `roles/twistlock`

### CyberArk
**Description**: Privileged access management  
**Key Features**: Credential vaulting, session management, threat analytics  
**Role**: `roles/cyberark`

---

## Version Control & Collaboration

### Git
**Description**: Distributed version control system  
**Key Features**: Branching, merging, distributed workflow  
**Role**: `roles/git`

### GitLab
**Description**: Complete DevOps platform  
**Key Features**: Git repository, CI/CD, issue tracking  
**Role**: `roles/gitlab`

### GitHub Enterprise
**Description**: Enterprise version of GitHub  
**Key Features**: Self-hosted, advanced security, enterprise features  
**Role**: `roles/github-enterprise`

### Gitea
**Description**: Lightweight self-hosted Git service  
**Key Features**: Easy installation, low resource usage, GitHub-like UI  
**Role**: `roles/gitea`

### Bitbucket
**Description**: Git repository management by Atlassian  
**Key Features**: Jira integration, pull requests, pipelines  
**Role**: `roles/bitbucket`

### Gerrit
**Description**: Code review for Git  
**Key Features**: Fine-grained access control, inline comments, voting  
**Role**: `roles/gerrit`

---

## Database & Storage

### PostgreSQL
**Description**: Advanced open-source relational database  
**Key Features**: ACID compliance, extensions, JSON support  
**Role**: `roles/postgresql`

### MySQL
**Description**: Popular open-source relational database  
**Key Features**: ACID compliance, replication, high performance  
**Role**: `roles/mysql`

### MariaDB
**Description**: MySQL fork with enhanced features  
**Key Features**: Better performance, more storage engines  
**Role**: `roles/mariadb`

### MongoDB
**Description**: Document-oriented NoSQL database  
**Key Features**: Flexible schema, horizontal scaling, rich queries  
**Role**: `roles/mongodb`

### Redis
**Description**: In-memory data structure store  
**Key Features**: Caching, pub/sub, persistence options  
**Role**: `roles/redis`

### Cassandra
**Description**: Distributed NoSQL database  
**Key Features**: High availability, linear scalability, no single point of failure  
**Role**: `roles/cassandra`

### Elasticsearch
**Description**: Distributed search and analytics engine  
**Key Features**: Full-text search, real-time analytics, scalable  
**Role**: `roles/elasticsearch`

### InfluxDB
**Description**: Time-series database  
**Key Features**: High write throughput, data compression, retention policies  
**Role**: `roles/influxdb`

### TimescaleDB
**Description**: Time-series database on PostgreSQL  
**Key Features**: SQL support, automatic partitioning, compression  
**Role**: `roles/timescaledb`

### CockroachDB
**Description**: Distributed SQL database  
**Key Features**: Horizontal scalability, ACID transactions, survivability  
**Role**: `roles/cockroachdb`

### Couchbase
**Description**: NoSQL document database  
**Key Features**: Memory-first architecture, N1QL queries, mobile sync  
**Role**: `roles/couchbase`

### MinIO
**Description**: High-performance object storage  
**Key Features**: S3 compatible, distributed, erasure coding  
**Role**: `roles/minio`

### Ceph
**Description**: Distributed storage system  
**Key Features**: Object, block, and file storage, self-healing  
**Role**: `roles/ceph`

---

## Web Servers & Proxies

### Nginx
**Description**: High-performance web server and reverse proxy  
**Key Features**: Load balancing, caching, HTTP/2 support  
**Role**: `roles/nginx`

### Apache HTTP Server
**Description**: Popular open-source web server  
**Key Features**: Modules, .htaccess, virtual hosts  
**Role**: `roles/apache`

### Caddy
**Description**: Modern web server with automatic HTTPS  
**Key Features**: Automatic TLS, HTTP/3, simple config  
**Role**: `roles/caddy`

### HAProxy
**Description**: High-performance load balancer  
**Key Features**: TCP/HTTP load balancing, health checks, SSL termination  
**Role**: `roles/haproxy`

### Traefik
**Description**: Modern HTTP reverse proxy and load balancer  
**Key Features**: Auto-discovery, Let's Encrypt, metrics  
**Role**: `roles/traefik`

### Envoy
**Description**: Cloud-native edge and service proxy  
**Key Features**: HTTP/2 & gRPC, advanced load balancing, observability  
**Role**: `roles/envoy`

### Kong
**Description**: Cloud-native API gateway  
**Key Features**: Plugin architecture, authentication, rate limiting  
**Role**: `roles/kong`

### NGINX Ingress Controller
**Description**: Kubernetes ingress controller  
**Key Features**: Load balancing, SSL termination, path-based routing  
**Role**: `roles/nginx-ingress`

---

## Cloud Platforms

### AWS CLI
**Description**: Command-line tool for Amazon Web Services  
**Key Features**: Service management, automation, scripting  
**Role**: `roles/aws-cli`

### Azure CLI
**Description**: Command-line tool for Microsoft Azure  
**Key Features**: Cross-platform, resource management, automation  
**Role**: `roles/azure-cli`

### Google Cloud SDK
**Description**: Tools for Google Cloud Platform  
**Key Features**: gcloud, gsutil, bq commands  
**Role**: `roles/gcloud-sdk`

### DigitalOcean CLI (doctl)
**Description**: Command-line tool for DigitalOcean  
**Key Features**: Droplet management, API access, automation  
**Role`: `roles/doctl`

### OpenStack Client
**Description**: Command-line client for OpenStack  
**Key Features**: Multi-service support, automation, unified CLI  
**Role`: `roles/openstack-client`

---

## Development Tools

### Node.js
**Description**: JavaScript runtime built on Chrome's V8 engine  
**Key Features**: NPM, event-driven, non-blocking I/O  
**Role**: `roles/nodejs`

### Python
**Description**: High-level programming language  
**Key Features**: pip, virtual environments, extensive libraries  
**Role**: `roles/python`

### Go
**Description**: Statically typed compiled language  
**Key Features**: Fast compilation, goroutines, standard library  
**Role**: `roles/golang`

### Java (OpenJDK)
**Description**: General-purpose programming platform  
**Key Features**: JVM, extensive ecosystem, cross-platform  
**Role**: `roles/openjdk`

### Rust
**Description**: Systems programming language  
**Key Features**: Memory safety, zero-cost abstractions, cargo  
**Role**: `roles/rust`

### Ruby
**Description**: Dynamic programming language  
**Key Features**: RubyGems, elegant syntax, Rails framework  
**Role**: `roles/ruby`

### Maven
**Description**: Build automation tool for Java  
**Key Features**: Dependency management, build lifecycle, plugins  
**Role**: `roles/maven`

### Gradle
**Description**: Build automation tool  
**Key Features**: Groovy/Kotlin DSL, incremental builds, multi-project  
**Role**: `roles/gradle`

### NPM/Yarn
**Description**: Package managers for JavaScript  
**Key Features**: Dependency management, scripts, workspaces  
**Role**: `roles/npm` / `roles/yarn`

### Visual Studio Code Server
**Description**: VS Code in the browser  
**Key Features**: Remote development, extensions, web-based  
**Role**: `roles/code-server`

---

## Configuration Management

### Ansible AWX
**Description**: Web-based UI for Ansible  
**Key Features**: Job scheduling, inventory management, REST API  
**Role**: `roles/awx`

### Chef
**Description**: Configuration management tool  
**Key Features**: Ruby DSL, cookbooks, idempotent  
**Role`: `roles/chef`

### Puppet
**Description**: Configuration management tool  
**Key Features**: Declarative language, master-agent, reporting  
**Role**: `roles/puppet`

### SaltStack
**Description**: Event-driven automation  
**Key Features**: Remote execution, configuration management, event-driven  
**Role**: `roles/saltstack`

### Consul
**Description**: Service mesh solution  
**Key Features**: Service discovery, health checking, KV store  
**Role**: `roles/consul`

### etcd
**Description**: Distributed key-value store  
**Key Features**: Strong consistency, watch API, leader election  
**Role**: `roles/etcd`

---

## Logging & Analytics

### ELK Stack (Elasticsearch, Logstash, Kibana)
**Description**: Complete log management solution  
**Key Features**: Log aggregation, analysis, visualization  
**Role**: `roles/elk-stack`

### Fluentd
**Description**: Unified logging layer  
**Key Features**: Plugin ecosystem, log forwarding, parsing  
**Role**: `roles/fluentd`

### Fluent Bit
**Description**: Lightweight log processor and forwarder  
**Key Features**: Low memory footprint, high performance  
**Role**: `roles/fluent-bit`

### Splunk
**Description**: Platform for operational intelligence  
**Key Features**: Log search, machine data analysis, dashboards  
**Role**: `roles/splunk-forwarder`

### Graylog
**Description**: Log management platform  
**Key Features**: Centralized logging, alerting, search  
**Role**: `roles/graylog`

### Loki
**Description**: Log aggregation system by Grafana Labs  
**Key Features**: Label-based indexing, Prometheus-like, cost-effective  
**Role**: `roles/loki`

---

## Networking Tools

### Calico
**Description**: Container networking solution  
**Key Features**: Network policy, BGP routing, encryption  
**Role**: `roles/calico`

### Cilium
**Description**: eBPF-based networking and security  
**Key Features**: API-aware networking, transparent encryption  
**Role**: `roles/cilium`

### Flannel
**Description**: Simple overlay network for Kubernetes  
**Key Features**: Easy setup, multiple backends  
**Role**: `roles/flannel`

### Weave Net
**Description**: Container networking solution  
**Key Features**: Automatic discovery, encryption, multicast  
**Role**: `roles/weave-net`

### MetalLB
**Description**: Load balancer for bare metal Kubernetes  
**Key Features**: BGP and L2 modes, IP address management  
**Role**: `roles/metallb`

---

## Testing & Quality Assurance

### Selenium
**Description**: Browser automation framework  
**Key Features**: Cross-browser testing, multiple languages  
**Role**: `roles/selenium-grid`

### JUnit
**Description**: Unit testing framework for Java  
**Key Features**: Annotations, assertions, test runners  
**Role**: Included with Java tools

### pytest
**Description**: Python testing framework  
**Key Features**: Simple syntax, fixtures, plugins  
**Role**: Included with Python tools

### JMeter
**Description**: Load testing tool  
**Key Features**: Performance testing, stress testing, distributed testing  
**Role**: `roles/jmeter`

### Gatling
**Description**: Load testing tool  
**Key Features**: Scala DSL, real-time metrics, CI/CD integration  
**Role`: `roles/gatling`

### Robot Framework
**Description**: Test automation framework  
**Key Features**: Keyword-driven, extensible, readable tests  
**Role**: `roles/robot-framework`

---

## Service Mesh

### Istio
**Description**: Service mesh platform  
**Key Features**: Traffic management, security, observability  
**Role**: `roles/istio`

### Linkerd
**Description**: Ultralight service mesh  
**Key Features**: Simple, fast, Kubernetes-native  
**Role**: `roles/linkerd`

### Consul Connect
**Description**: Service mesh by HashiCorp  
**Key Features**: Service-to-service encryption, intentions  
**Role**: `roles/consul-connect`

---

## Usage Examples

### Installing a Single Tool

```yaml
- hosts: servers
  roles:
    - prometheus
```

### Installing Multiple Tools

```yaml
- hosts: servers
  roles:
    - docker
    - kubernetes
    - prometheus
    - grafana
```

### Customizing Installation

```yaml
- hosts: servers
  roles:
    - role: prometheus
      vars:
        prometheus_version: "2.40.0"
        prometheus_port: 9090
```

---

## Contributing New Tools

To add a new DevOps tool to this reference:

1. Create the Ansible role in the `roles/` directory
2. Add documentation to the role's README.md
3. Update this reference document with the tool details
4. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

**[Back to README](README.md)** | **[Contributing Guidelines](CONTRIBUTING.md)**
