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