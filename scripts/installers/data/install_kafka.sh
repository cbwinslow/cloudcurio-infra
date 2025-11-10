#!/bin/bash

################################################################################
# Apache Kafka Installation Script
# 
# Description: Installs Apache Kafka distributed event streaming platform
# Author: CloudCurio Infrastructure Team
# Version: 1.0.0
#
# Usage: sudo bash install_kafka.sh
################################################################################

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'
readonly KAFKA_VERSION="3.6.0"
readonly SCALA_VERSION="2.13"
readonly INSTALL_DIR="/opt/kafka"
readonly LOG_FILE="/tmp/kafka_install_$(date +%Y%m%d_%H%M%S).log"

log_info() { echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"; }

check_root() {
    [[ $EUID -ne 0 ]] && log_error "Must run as root" && exit 1
}

install_java() {
    log_info "Installing Java..."
    apt-get update
    apt-get install -y openjdk-11-jdk
}

install_kafka() {
    log_info "Installing Kafka ${KAFKA_VERSION}..."
    
    cd /tmp
    wget "https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
    tar -xzf "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
    mv "kafka_${SCALA_VERSION}-${KAFKA_VERSION}" "$INSTALL_DIR"
    
    # Create systemd services
    cat > /etc/systemd/system/zookeeper.service <<EOF
[Unit]
Description=Apache Zookeeper
After=network.target

[Service]
Type=simple
User=root
ExecStart=${INSTALL_DIR}/bin/zookeeper-server-start.sh ${INSTALL_DIR}/config/zookeeper.properties
ExecStop=${INSTALL_DIR}/bin/zookeeper-server-stop.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    cat > /etc/systemd/system/kafka.service <<EOF
[Unit]
Description=Apache Kafka
After=zookeeper.service

[Service]
Type=simple
User=root
ExecStart=${INSTALL_DIR}/bin/kafka-server-start.sh ${INSTALL_DIR}/config/server.properties
ExecStop=${INSTALL_DIR}/bin/kafka-server-stop.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable zookeeper kafka
    systemctl start zookeeper
    sleep 10
    systemctl start kafka
}

main() {
    check_root
    install_java
    install_kafka
    log_info "Kafka installed at $INSTALL_DIR. Broker: localhost:9092"
}

trap 'log_error "Failed at line $LINENO"' ERR
main "$@"
