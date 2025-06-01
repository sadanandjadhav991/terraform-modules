#!/bin/bash
set -e

swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab
setenforce 0
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
EOF

sysctl --system

# Install containerd
yum install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl enable --now containerd

# Kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
EOF

yum install -y kubelet kubeadm kubectl
systemctl enable --now kubelet
