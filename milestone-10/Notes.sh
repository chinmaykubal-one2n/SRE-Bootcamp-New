kubectl create namespace observability
# Postgresql Exporter:-
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install postgres-exporter prometheus-community/prometheus-postgres-exporter -f ADDONS/Vaules_PostgreSQL_Exporter.yaml --namespace observability
# install prometheus
# helm install prometheus prometheus-community/prometheus -f ADDONS/Values_Prometheous.yaml --namespace observability


# stack helm chart
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f ADDONS/Values_kube-prometheus-stack.yaml --namespace observability
----------------------------------------------------------------------------------------
FOR NOW
kubectl create namespace observability
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f ADDONS/kube-exporter-default-manipulated.yaml --namespace observability
kubectl create secret generic kube-secret-postgres-db-exporter \
  --from-literal=DATABASE_URL="postgres://postgres:postgres@postgres-service.student-api.svc.cluster.local:5432/postgres?sslmode=disable" \
  -n observability

helm install postgres-exporter prometheus-community/prometheus-postgres-exporter -f ADDONS/Vaules_PostgreSQL_Exporter.yaml --namespace observability

# prometheus is already added to grafana just add postgresql exporter to promethsues also
#  get fresh new values for kube-prometheus-stack and then add


DASHBOARDS
FULL Node Exporter:- 1860
kube-state-metrics-v2:- 13332
PostgreSQL Exporter:-  14114, 13576
# Prometheus Blackbox Exporter:- 7587
# loki :- 15141
12485


(lets do loki-stack afterwards, first focus on kube-prometheus-stack and all exporters and prpmethsus and grafana )
# currently active
vault kv put secret/postgres-secrets \
    DATABASE_URL='postgres://postgres:postgres@postgres-service.student-api.svc.cluster.local:5432/postgres?sslmode=disable' \
    POSTGRES_USER='postgres' \
    POSTGRES_HOST='postgres-service.student-api.svc.cluster.local' \
    POSTGRES_PASSWORD='postgres' \
    POSTGRES_DB='postgres' \
    PGDATA='/var/lib/postgresql/data'

kubectl create namespace observability
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f ADDONS/values_kube-prometheus-stack.yaml --namespace observability
helm install postgres-exporter prometheus-community/prometheus-postgres-exporter -f ADDONS/values_postgres-exporter.yaml --namespace student-api

helm install blackbox-exporter prometheus-community/prometheus-blackbox-exporter --namespace observability
# from the below helm chart disable the unwanted pods (DAMN IMP) (bb exportet is there )
# helm install prometheus-operator oci://registry-1.docker.io/bitnamicharts/kube-prometheus -n observability
# helm install loki-stack grafana/loki-stack -f ../randomlokistack.yaml -n observability
# node is not settled for now. 

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update



CUTTENTL WORKING:- (setup nodeaffinity afterwards)
vault kv put secret/postgres-secrets \
    DATABASE_URL='postgres://postgres:postgres@postgres-service.student-api.svc.cluster.local:5432/postgres?sslmode=disable' \
    POSTGRES_USER='postgres' \
    POSTGRES_HOST='postgres-service.student-api.svc.cluster.local' \
    POSTGRES_PASSWORD='postgres' \
    POSTGRES_DB='postgres' \
    PGDATA='/var/lib/postgresql/data'
kubectl create namespace observability
helm install postgres-exporter prometheus-community/prometheus-postgres-exporter -f ADDONS/values_postgres-exporter.yaml --namespace student-api
helm install loki-stack grafana/loki-stack --namespace observability -f ADDONS/values_loki-stack.yaml
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f ADDONS/values_kube-prometheus-stack.yaml --namespace observability

sudo sh -c 'echo "fs.inotify.max_user_instances=8192" >> /etc/sysctl.conf'
sudo sh -c 'echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf'

sudo sysctl -p

sysctl fs.inotify.max_user_instances
sysctl fs.inotify.max_user_watches


ARGOCD-APPLICATOIN FILE NEEDS TO BE CHANGED AFTER THE MERGE FORM NOW POINTING THE MILESTONE-10-NEW CHANGE IT TO MAIN AFTERWARDS
helm install blackbox-exporter prometheus-community/prometheus-blackbox-exporter --namespace observability -f ADDONS/black-box-values.yaml


(time() - process_start_time_seconds{job="postgres-exporter-prometheus-postgres-exporter", namespace="student-api"}) / 3600 hours
(time() - process_start_time_seconds{job="postgres-exporter-prometheus-postgres-exporter", namespace="student-api"}) / 86400 days


loki (not test command for alerts) 
count_over_time({app="students-api"} |= `200` [1m])
count_over_time({app="students-api"} |= `404` [1m])
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) > 50
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 20
100 * (node_filesystem_size_bytes{mountpoint="/"} - node_filesystem_free_bytes{mountpoint="/"}) / node_filesystem_size_bytes{mountpoint="/"} > 5




Bot User OAuth Token:-  
while working with grafana getting this error :- NetworkError when attempting to fetch resource.
but pods are running fine.
logs are also okay.
