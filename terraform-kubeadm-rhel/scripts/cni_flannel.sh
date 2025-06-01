#!/bin/bash
set -euxo pipefail

# This script installs Flannel CNI on the master node after kubeadm init

# Variables
POD_CIDR=${1:-"10.244.0.0/16"}  # default if not provided

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
  echo "kubectl not found. Please install it before running this script."
  exit 1
fi

# Apply Flannel CNI
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

echo "✅ Flannel CNI applied successfully"
