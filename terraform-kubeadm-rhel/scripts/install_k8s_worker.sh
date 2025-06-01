#!/bin/bash
set -e

source /tmp/common.sh

# kubeadm join
if [ ! -f /etc/kubernetes/kubelet.conf ]; then
  kubeadm join ${MASTER_IP}:6443 --token ${JOIN_TOKEN} \
    --discovery-token-ca-cert-hash ${DISCOVERY_HASH}
fi
