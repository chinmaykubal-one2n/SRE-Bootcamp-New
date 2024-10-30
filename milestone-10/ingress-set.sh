minikube addons enable ingress
kubectl apply -f student-api-ingress.yaml

minikube ip
sudo nano /etc/hosts
    192.168.49.2 students-api.local
curl http://students-api.local/api/v1/healthcheck
