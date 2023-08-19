

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


#  extra changes 
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo nano /etc/containerd/config.toml # set SystemdCgroup = true
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


# changes has to be made manually 
sudo swapoff -a
sudo nano /etc/fstab #delete eveyrhting inside the file 
# 

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl


# new kubeadm installing 
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl



#  Master 

sudo kubeadm config images pull

sudo kubeadm init --ignore-preflight-errors=all

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#  fot the master core nodes not working we need to install the network like flannel or weavenet CNI plugin
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml


# current problem with kubelet 
# ! somehow it is not working and fails status check from ubuntu





