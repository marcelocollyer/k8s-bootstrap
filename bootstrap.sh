#!/bin/bash

k3d cluster delete
k3d cluster create -p "8000:30000@loadbalancer" --agents 2

# Uncomment this in case you want to use minikube instead of k3d
#minikube delete
#minikube start --cpus 4 --memory 15000

# Install Istio and include it to PATH
eval "$(curl -L https://istio.io/downloadIstio | sh - | sed -n '/export PATH.*/p')"

# Install Istio and set it to work with default namespace (use specific namespaces for your apps in prod!)
kubectl create namespace istio-system
istioctl install -y
kubectl label namespace default istio-injection=enabled

# addons
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/addons/grafana.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/addons/kiali.yaml

# sets context to work on default namespace
kubectl config set-context --current --namespace default

# deploy pods, replicaset, services, virtual services and destination
kubectl apply -f ./cluster-resources/.

#let's give kiali some time to load. 30s is probably enough
sleep 30

# start kiali dashboard
istioctl dashboard kiali &