minikube start --driver=docker --nodes 4
kubectl label nodes minikube-m02 type=application
kubectl label nodes minikube-m03 type=database
kubectl label nodes minikube-m04 type=dependent_services



# helm repo update
kubectl create namespace vault-ns
kubectl create namespace student-api
kubectl create namespace external-secrets

# helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault --values helm-vault-raft-values.yml --namespace vault-ns


# helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets \
  --namespace external-secrets \
  --values external-secrets-operator.yaml
  

kubectl port-forward vault-0 8200:8200 -n vault-ns


kubectl exec  -n vault-ns vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json

cat cluster-keys.json | jq -r ".unseal_keys_b64[]"

VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")

kubectl exec  -n vault-ns vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY

cat cluster-keys.json | jq -r ".root_token"

kubectl exec  -n vault-ns --stdin=true --tty=true vault-0 -- /bin/sh

vault login 
# (use the passcode from the command:- cat cluster-keys.json | jq -r ".root_token" )

vault secrets enable -path=secret kv-v2

vault auth enable kubernetes


vault kv put secret/postgres-secrets \
    DATABASE_URL='postgres://postgres:postgres@postgres-service.student-api.svc.cluster.local:5432/postgres' \
    POSTGRES_USER='postgres' \
    POSTGRES_HOST='postgres-service.student-api.svc.cluster.local' \
    POSTGRES_PASSWORD='postgres' \
    POSTGRES_DB='postgres' \
    PGDATA='/var/lib/postgresql/data'

exit


kubectl apply -f 1.ss-vault-token-secret.yaml (modify this first)
kubectl get secrets -n student-api

kubectl apply -f 2.ss.yaml
kubectl get secretstore.external-secrets -n student-api

kubectl apply -f es.yaml
kubectl get externalsecret.external-secrets.io -n student-api

kubectl apply -f api-1-database.yml
# wait
kubectl apply -f api-2-application.yml

kubectl port-forward --address 0.0.0.0 service/students-api-service 3000:3000 -n student-api


kubectl port-forward --address 0.0.0.0 service/students-api-service 3000:3000 -n student-api


<!-- https://chatgpt.com/share/67173d7a-d218-8012-ab08-d81feaa678fc -->