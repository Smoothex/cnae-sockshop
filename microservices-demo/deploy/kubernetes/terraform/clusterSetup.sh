master_ip=$(terraform output -json | jq -r '.master_address.value')

scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no -rp ../manifests ubuntu@$master_ip:/tmp/
scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no -rp ../complete-demo.yaml ubuntu@$master_ip:/tmp/complete-demo.yaml

sleep 3

# ssh -i ~/.ssh/deploy-docs-k8s.pem ubuntu@$master_ip sudo kubeadm init > k8s-init.log
# ! might have problem with the followring command to setup kubeadm environment
ssh -i ~/.ssh/deploy-docs-k8s.pem ubuntu@$master_ip sudo kubeadm init --ignore-preflight-errors=all --pod-network-cidr=192.168.0.0/16 > k8s-init.log