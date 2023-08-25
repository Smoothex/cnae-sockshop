kubectl apply -f /tmp/Complete_parts_new/complete1.yaml
sleep 10
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts_new/complete2.yaml
sleep 10
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts_new/complete3.yaml
sleep 15
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts_new/complete4.yaml
sleep 15
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts_new/complete5.yaml
sleep 20
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts_new/complete6.yaml
sleep 20
kubectl get nodes && kubectl get pods -n sock-shop
sleep 3
kubectl apply -f /tmp/Complete_parts_new/complete7.yaml
sleep 20

echo "Deployment complete showing results"
kubectl get nodes && kubectl get pods -A
echo "Initial Deployment complete !!!!!"

sleep 40
echo "Starting auto scaling"
kubectl apply -f /tmp/Complete_parts_new/complete8.yaml
sleep 20

