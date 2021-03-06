#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE}")
ROOT_DIR=$(dirname "${BASH_SOURCE}")/..
source "${ROOT_DIR}/hack/common.sh"

# Used in deploy.sh
export DOCKER_USERNAME="${DOCKER_CREDS_USR:-}"
export DOCKER_PASSWORD="${DOCKER_CREDS_PSW:-}"

export HDFS_NAMENODE_STORAGE_SIZE="20Gi"
export HDFS_DATANODE_STORAGE_SIZE="30Gi"

export UNINSTALL_METERING_BEFORE_INSTALL="${UNINSTALL_METERING_BEFORE_INSTALL:-false}"

"$DIR/deploy-custom.sh"

echo "Deploying default Reports"

HOURLY=( \
    "$MANIFESTS_DIR/reports/cluster-capacity-hourly.yaml" \
    "$MANIFESTS_DIR/reports/cluster-usage-hourly.yaml" \
    "$MANIFESTS_DIR/reports/cluster-utilization-hourly.yaml" \
    "$MANIFESTS_DIR/reports/namespace-usage-hourly.yaml" \
)
DAILY=( \
    "$MANIFESTS_DIR/reports/cluster-capacity-daily.yaml" \
    "$MANIFESTS_DIR/reports/cluster-usage-daily.yaml" \
    "$MANIFESTS_DIR/reports/cluster-utilization-daily.yaml" \
    "$MANIFESTS_DIR/reports/namespace-usage-daily.yaml" \
)

echo "Creating hourly reports"
kube-install "${HOURLY[@]}"
echo "Creating daily reports"
kube-install "${DAILY[@]}"
