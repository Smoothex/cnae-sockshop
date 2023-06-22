The [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server) is a component in Kubernetes that collects resource utilization metrics from various components in the cluster, including nodes and pods. It provides these metrics to other components, such as the Kubernetes Horizontal Pod Autoscaler (HPA) and the kubectl top command.

The Metrics Server collects metrics related to CPU and memory usage, as well as other resource utilization data. It regularly polls the Kubernetes API server to retrieve metrics from the nodes and pods in the cluster.

## Start the metrics server
Apply the configuration file with kubectl:
```
kubectl -n kube-system apply -f components.yaml
```

You can check if the metrics server pod is running in the _kube-system_ namespace with  `kubectl get pods -n kube-system`.

After some time, after the metrics server has started scraping the pods, you can see how much resources each pod is using:
```
kubectl -n sock-shop top pods
```

You can read more about the resource units for CPU and the memory in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes).