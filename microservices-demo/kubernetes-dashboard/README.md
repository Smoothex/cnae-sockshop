## Deploy Dashboard
For this, simply execute following command from the current folder:
```
kubectl apply -f kubernetes-dashboard.yaml
```
## Accessing Dashboard
Executing this command starts a local HTTP proxy server on your machine and forwards requests to the Kubernetes API server:
```
kubectl proxy
```
This will make the dashboard available at
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

### Dashboard Login
When you access Dashboard for the first time, you will be prompted to login with either Kubeconfig or a Bearer Token:

![image](https://github.com/Smoothex/cnae-sockshop/assets/79105432/7db32dff-4bc2-4fc0-9443-f64592ca7900)

### Obtaining a token

To create a token, we need to create a new user with [Kubernetes Service Account](https://kubernetes.io/docs/concepts/security/service-accounts/). For this, execute the following command to create a Service Account named `admin-user`:
```
kubectl apply -f dashboard-admin-user.yaml
```
Verify the `CLusterRole` named `cluster-admin` exists in your cluster:
```
kubectl get clusterroles
```
The `cluster-admin` role should be one of the first ones to see. If not, then you would need to create this role first and grant it the needed privileges. This [Kubernetes documentation article](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#kubectl-create-clusterrole) might be useful here.

Once you have made sure the role exists, execute this command to create a `ClusterRoleBinding` to the `ServiceAccount` we created in one of the previous steps:
```
kubectl apply -f cluster-role-binding.yaml
```

We are now ready to create a bearer token named `admin-user` that we can use to log in as an administrator to the Kubernetes Dashboard:
```
kubectl -n kubernetes-dashboard create token admin-user
```
The output should look like this:
```
eyJhbGciOiJSUzI1NiIsImtpZCI6IlB1QmJndTBzY0VOUm9LQktETkkwa3QzVUpHX2dJaUVtdUdFN1hOb1drRnMifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiXSwiZXhwIjoxNjg3NTEyNDIxLCJpYXQiOjE2ODc1MDg4MjEsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJhZG1pbi11c2VyIiwidWlkIjoiNDRkOGM3YjItYzhmYS00MWY0LWI0YjAtNTU5ZjZhYWJhNTIwIn19LCJuYmYiOjE2ODc1MDg4MjEsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDphZG1pbi11c2VyIn0.31Oo_j9Diz5UCJUj7MWVgPpJorzYnUixgacdE5Ex31OeaGa8VZNf7NykRzKb0IsY3CqKnutVKpCJKb1v2o1BPP-yqtyBibiAHNR1L5ZS_C9aXcMD1rYMZ-g6U5xwtqu-mkKusifsdZM0PBk-K6Mxdy0_V8DgfV8GMoSWzthXP-Rvc8NUSG99Mv2ptRttch7agh0if-HjglzBWyWSYer-8VT6pt1WPAJvkl_-cT4-H1BK7hOQMuSMyhuLGY4PsHE228fBn1GS_CX6AW3yvab21xkf586ekbTVytCYeAjp64FomHb6hm0Up9L9Skgk_hP4fJcHyt8Hrv4n_uqIWs8r4w
```

Copy and paste this token in the prompt in the Kubernetes Dashboard and sign in.

You can now choose a namespace and retrieve configuration info about nodes and pods as well as see the metrics scraped by the `metrics-server`.

![image](https://github.com/Smoothex/cnae-sockshop/assets/79105432/12b98baf-31a7-415f-b4d3-04519a86c118)

Sources:

* [Kubernetes Dashboard GitHub](https://github.com/kubernetes/dashboard)

* The article [Collecting metrics with built-in Kubernetes monitoring tools](https://www.datadoghq.com/blog/how-to-collect-and-graph-kubernetes-metrics/#browse-cluster-objects-in-kubernetes-dashboard)
