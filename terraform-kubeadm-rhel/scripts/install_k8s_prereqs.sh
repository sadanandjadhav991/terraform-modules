#!/bin/bash
set -euxo pipefail

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Disable SELinux (set to permissive)
setenforce 0 || true
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Enable kernel modules
modprobe br_netfilter
modprobe overlay

# Set sysctl params
cat <<EOF | tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# Install containerd
yum install -y yum-utils device-mapper-persistent-data lvm2
yum install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl enable --now containerd

# Add Kubernetes repo
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
EOF

# Install Kubernetes components
yum install -y kubelet kubeadm kubectl
systemctl enable --now kubelet
