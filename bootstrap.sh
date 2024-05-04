#!/bin/bash

# Install Istio and include it to PATH
eval "$(curl -L https://istio.io/downloadIstio | sh - | sed -n '/export PATH.*/p')"

# start clean cluster
minikube delete
minikube start --cpus 4 --memory 8192

# Create namespace for Argo CD
kubectl create namespace argocd
# Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install Istio and set it to work with default namespace (use specific namespaces for your apps in prod!)
kubectl create namespace istio-system
istioctl install --set profile=default -y
kubectl label namespace default istio-injection=enabled

# addons
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/addons/jaeger.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/addons/grafana.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/addons/kiali.yaml

# install minikube addons for elastic stack to work properly
minikube addons enable default-storageclass
minikube addons enable storage-provisioner

# Install custom resource definitions:
kubectl create -f https://download.elastic.co/downloads/eck/2.12.1/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.12.1/operator.yaml

#install elasticsearch, kibana and apm
kubectl apply -f ./elastic/.

echo "Waiting for elastisearch to be ready..."
while true; do
    # get elasticsearch current state
    STATUS=$(kubectl get elasticsearch quickstart --namespace elastic-system -o=jsonpath='{.status.health}')
    
    # check if it's "green" state (meaning elasticsearch is running properly)
    if [[ "$STATUS" == "green" ]]; then
        echo "Elasticsearch is ready!"
        break
    else
        sleep 2
    fi
done

# Fetch and decode the encoded data directly
echo "Kibana password: $(kubectl get secret quickstart-es-elastic-user --namespace elastic-system -o go-template='{{.data.elastic}}' | base64 --decode)"

# Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
# create service and permission
kubectl apply -f ./k8s-dashboard/dashboard-adminuser.yaml
# creates a baerier token for kubernetes-dashboard
kubectl -n kubernetes-dashboard create token admin-user
# prints kubernetes dashboard baerer token
echo "k8s dashboard password: $(kubectl -n kubernetes-dashboard create token admin-user)"

# sets context to work on default namespace
kubectl config set-context --current --namespace default

# deploy simple nginx pods, replicaset and service
kubectl apply -f deployment.yaml