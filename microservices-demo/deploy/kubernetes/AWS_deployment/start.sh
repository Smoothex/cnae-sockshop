#!/bin/bash
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
# sudo wget https://github.com/containerd/containerd/releases/download/v1.6.16/containerd-1.6.16-l
sudo wget https://github.com/containerd/containerd/releases/download/v1.7.3/containerd-1.7.3-linux-amd64.tar.gz
sudo tar Cxzvf /usr/local containerd-1.7.3-linux-amd64.tar.gz
sudo wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mkdir -p /usr/local/lib/systemd/system
sudo mv containerd.service /usr/local/lib/systemd/system/containerd.service
sudo systemctl daemon-reload
# sudo systemctl enable --now containerd
sudo systemctl enable containerd

sudo wget https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
wget https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.2.0.tgz
VERSION="v1.26.0" # check latest version in /releases page
sudo wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
sudo rm -f crictl-$VERSION-linux-amd64.tar.gz


#  set default congig to systemCgroup
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
# sudo nano /etc/containerd/config.toml # set SystemdCgroup = true
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl status containerd



sudo cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false
EOF


sudo cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
sudo sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
sudo modprobe br_netfilter
sudo sysctl -p /etc/sysctl.conf


# delete swap memory
sudo swapoff -a
sudo truncate -s 0 /etc/fstab

# install kuebernetes  
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl
# hold the version in order to avoid changes to the version or API
sudo apt-mark hold kubelet kubeadm kubectl



