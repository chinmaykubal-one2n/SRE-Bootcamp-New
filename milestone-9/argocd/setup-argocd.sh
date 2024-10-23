#!/bin/bash

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

for deployment in $(kubectl get deployments -n argocd -o jsonpath='{.items[*].metadata.name}'); do
  kubectl patch deployment -n argocd $deployment \
  --patch '{"spec": {"template": {"spec": {"nodeSelector": {"type": "dependent_services"}}}}}'
done

for statefulset in $(kubectl get statefulsets -n argocd -o jsonpath='{.items[*].metadata.name}'); do
  kubectl patch statefulset -n argocd $statefulset \
  --patch '{"spec": {"template": {"spec": {"nodeSelector": {"type": "dependent_services"}}}}}'
done


# kubectl get secret argocd-initial-admin-secret -n argocd -o yaml | grep -i 'password' | awk {'print $2'} | base64 -d
