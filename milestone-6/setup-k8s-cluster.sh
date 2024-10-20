#!/bin/bash

minikube start --driver=docker --nodes 4
kubectl label nodes minikube-m02 type=application
kubectl label nodes minikube-m03 type=database
kubectl label nodes minikube-m04 type=dependent_services

# minikube stop
# minikube delete


