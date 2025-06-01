#!/bin/bash
set -e

source /tmp/common.sh

# kubeadm init
if ! kubectl version --client &> /dev/null; then
  kubeadm init --pod-network-cidr=${POD_CIDR} --apiserver-advertise-address=${ADVERTISE_ADDRESS} \
    --upload-certs | tee /tmp/kubeadm-init.log

  mkdir -p $HOME/.kube
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  chown $(id -u):$(id -g) $HOME/.kube/config
fi
