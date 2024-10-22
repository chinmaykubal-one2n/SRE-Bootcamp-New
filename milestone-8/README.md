## Milestone:- 8 - Deploy REST API & its dependent services using Helm Charts
## Prerequisites


Make sure you have the following installed on your system:

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fdebian+package)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)



### Follow these steps to set up the Student API:

### Step 1: Start Minikube with 4 Nodes
To start Minikube with Docker as the driver and 4 nodes, run the following command:

```bash
minikube start --driver=docker --nodes 4
```

### Step 2: Label the Nodes
Label the nodes for the application, database, and dependent services:
```bash
kubectl label nodes minikube-m02 type=application
kubectl label nodes minikube-m03 type=database
kubectl label nodes minikube-m04 type=dependent_services
```

### Step 3: Create Namespaces
Create namespaces for Vault and External Secrets:
```bash
kubectl create namespace vault-ns
kubectl create namespace external-secrets
```

### Step 4: Install Vault using Helm
Update Helm repositories and install Vault with Raft storage configuration:
```bash
helm repo update
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault \
  --values helm-vault-raft-values.yml \
  --namespace vault-ns
```

### Step 5: Install External Secrets using Helm
Add the External Secrets Helm repository and install it:
```bash
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets \
  --namespace external-secrets \
  --values external-secrets-operator.yaml
```
### Step 6: Port Forward Vault for UI Access
Forward port 8200 to access Vault:
```bash
kubectl port-forward vault-0 8200:8200 -n vault-ns
```

### Step 7: Initialize and Unseal Vault
Initialize Vault with 1 key share and threshold, and store the cluster keys:
```bash
kubectl exec -n vault-ns vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json

cat cluster-keys.json | jq -r ".unseal_keys_b64[]"
```
Unseal Vault:
```bash
VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")
kubectl exec -n vault-ns vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
```
Get the root token:
```bash
cat cluster-keys.json | jq -r ".root_token"
```

### Step 8: Log into Vault and Enable Secrets
Log into Vault using the root token:
```bash
kubectl exec -n vault-ns --stdin=true --tty=true vault-0 -- /bin/sh
vault login
```
(Use the passcode obtained from the command:)
```bash
cat cluster-keys.json | jq -r ".root_token"
```

Enable KV version 2 secrets engine:
```bash
vault secrets enable -path=secret kv-v2
```

Enable Kubernetes auth:
```bash
vault auth enable kubernetes
```

### Step 9: Add Secrets
Store Postgres secrets in Vault:
```bash
vault kv put secret/postgres-secrets \
    DATABASE_URL='postgres://postgres:postgres@postgres-service.student-api.svc.cluster.local:5432/postgres' \
    POSTGRES_USER='postgres' \
    POSTGRES_HOST='postgres-service.student-api.svc.cluster.local' \
    POSTGRES_PASSWORD='postgres' \
    POSTGRES_DB='postgres' \
    PGDATA='/var/lib/postgresql/data'
```

To get out of the pod
```bash
exit
```


### Step 10: Install Student API with Helm
For the file 02-vault-token-secret.yaml in helm chart, modify the token in values.yaml before installing the Student API Helm chart:
```bash
helm install student-api ./helm-chart
```

### Step 11: Access the Student API
Port forward the Student API service to make it accessible:
```bash
kubectl port-forward --address 0.0.0.0 service/students-api-service 3000:3000 -n student-api
```

### Step 12: Start the Postman
Start the postman and import the student-api.postman_collection.json and start reaching the respective endpoints