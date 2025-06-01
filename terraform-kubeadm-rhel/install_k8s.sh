#!/bin/bash
set -e

# Disable SELinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Load kernel modules
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# Configure sysctl
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sysctl --system

# Install Containerd
yum install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl enable --now containerd

# Add Kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
EOF

# Install Kubernetes tools
yum install -y kubelet kubeadm kubectl
systemctl enable --now kubelet

# Initialize the cluster (only on master node)
if [ "$1" == "master" ]; then
  kubeadm init --pod-network-cidr=10.244.0.0/16

  mkdir -p $HOME/.kube
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  chown $(id -u):$(id -g) $HOME/.kube/config

  # Install flannel CNI
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
fi
