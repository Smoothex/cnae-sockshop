# Sock Shop: Enhanced Performance through Elastic Scalability

We aim to improve the microservices demo application [Sock Shop](https://github.com/microservices-demo/microservices-demo) by WeaveWorks by introducing autoscaling techniques.

## Goal and approach
Our goal is for the app to scale up, when there is an increase in traffic and scale down, when the load goes down.

For this, we utilize the load testing tool [Locust](https://github.com/locustio/locust) to simulate user behaviour. This way, we can identify the microservice(s) that is (are) performing worse than the others and tune the bottleneck(s) to perform better.

Some of the possible autoscaling techniques are:
- modifying its pod's [resource requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits)
- introducing a [Horizontal Pod Autoscaler (HPA)](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- making (part of the) microservice serverless

Get familiar with the Sock Shop architecture and the monitoring tools we use in the [repo's Wiki](https://github.com/Smoothex/cnae-sockshop/wiki).
