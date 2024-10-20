## Milestone:-  6 - Setup Kubernetes cluster


## Prerequisites


Make sure you have the following installed on your system:

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fdebian+package)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)



### Follow these steps:


### To start the minikube
```bash
chmod +x setup-k8s-cluster.sh && ./setup-k8s-cluster.sh
```

### To stop the minikube
```bash
minikube stop
```

### To delete the k8s cluster in minikube
```bash
minikube delete
```