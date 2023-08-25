kubectl apply -f /tmp/Complete_parts/complete1.yaml
sleep 10
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts/complete2.yaml
sleep 10
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts/complete3.yaml
sleep 15
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts/complete4.yaml
sleep 15
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts/complete5.yaml
sleep 20
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts/complete6.yaml
sleep 20
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts/complete7.yaml
sleep 20

echo "Deployment complete showing results"
kubectl get nodes && kubectl get pods -A
echo "Deployment complete !!!!!"