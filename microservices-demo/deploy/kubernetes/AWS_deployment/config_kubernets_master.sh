sudo kubeadm init --ignore-preflight-errors=all > k8init.log
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#  fot the master core nodes not working we need to install the network like flannel or weavenet CNI plugin
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
echo "waiting for initialization...."
sleep 5
cat k8init.log