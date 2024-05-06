# Microservices Architecture: Seamless Deployment and Communication Synchronization with Kubernetes and Istio

## Overview
In the realm of modern software development, the orchestration of microservices across cloud environments can pose significant challenges, particularly when deploying new versions. Organizations often rely on multiple interdependent services, written in various languages and hosted on cloud platforms like Amazon AWS, each on its own EC2 instance. The introduction of Kubernetes and Istio into this mix revolutionizes the way we handle these complexities.

Consider the challenge of ensuring that, upon a new blue-green or canary deployment, a payment microservice in version 2 should only communicate with other services of the same version. When both old and new versions need to run simultaneously, synchronization becomes crucial. This scenario often raises the question: How can we guarantee that all interactions between microservices are version-appropriate, especially when new versions may require API end-points that previous versions do not support?

## Technologies Used
- **Kubernetes**: This leading container orchestration tool automates the deployment, scaling, and management of containerized applications, simplifying operations across clustered environments.
- **Istio**: This cutting-edge service mesh optimizes service-to-service communication across microservices, enhancing security, connectivity, and monitoring capabilities.
- **Kiali**: A visualization tool that provides insights into the traffic flow and interactions among microservices, facilitating the management of Istio's configurations and ensuring effective rule enforcement.
- **Monitoring and Observability Tools**:
  - **Prometheus & Grafana**: For real-time monitoring and visualization.
  - **ELK Stack (Elasticsearch, Logstash, Kibana)**: For comprehensive logging and search capabilities.
  - **Jaeger**: For tracing and visualizing request flows within the service mesh.
- **Kubernetes Dashboard & ArgoCD**: These facilitate streamlined management and continuous deployment processes, enabling more efficient operation workflows.

## Project Structure
```plaintext
├── cluster-resources         # Deployment related yaml files
├── elastic/                  # ELK stack yaml files
├── k8s-dashboard/            # Kubernetes dashboard yaml files
├── microservices/            # Source code for each microservice
│   ├── microservice-a/       # NodeJS containerized microservice that serves as an entry point and calls microservice-b
│   ├── microservice-b/       # Golang containerized microservice that receives request from microservice-a and calls microservice-c
│   └── microservice-c/       # Python containerized microservice that receives request from microservice-b and returns its own 
└── bootstrap.sh              # Script to setup the basic infrastructure from ground up
```
## Before getting started
Before getting started with this project, ensure that you have the following prerequisites installed on your local machine:
- **Docker**: This is a containerization platform used to run applications in isolated environments. It provides an easy way to package and deploy software components.
- **kubectl**: This command line tool allows you to interact with Kubernetes clusters. It's essential for managing deployments, scaling, and monitoring.
- **Helm**: Helm is a package manager that simplifies the installation of Kubernetes resources. It helps automate the deployment process by providing preconfigured configurations.
- **K3D**: K3D is a lightweight wrapper that runs k3s (a lightweight Kubernetes distribution) in Docker. It's great for local development and testing, providing a quick and easy way to spin up a Kubernetes cluster.

Kubernetes is known to be resource intensive so I recommend at least 4 CPU cores and 8 GB of RAM dedicated to Docker.</br>
I executed this proof of concept on a M1 Max 32GB of RAM but I believe it might work on a smaller machine as well.</br>
As mentioned, it has not been tested on a linux or a WSL 2 environment but I strongly believe it should work. I'll update this note once I run these tests.</br>
I would definately appreciate feedbacks! :-)

Important to remind that, not all of the tools used in this POC are necessary to get the main objective accomplished, so you might want to remove some of them from the bootstrap 
script in case you have a more limited resources machine.

## Main Objetives
- Deploy a local Kubernetes cluster using K3D.
- Deploy an Istio service mesh.
- Setup Kiali to visualize traces between services within the mesh.
- Configure Prometheus to scrape metrics from the microservices deployed in the cluster.
- Setup a Grafana dashboard to visualize metrics and logs from the microservices deployed in the cluster.
- Build and deploy three microservices that talk to each other to be used as our targets
- Setup Virtual Services and Destination Rules to route traffic between services within the mesh.

## Secondary Objetives (optional)
- Setup a Jaeger service to trace requests between services within the mesh.
- Configure ELK stack to collect logs and visualize metrics from the microservices deployed in the cluster.
- Setup ArgoCD to rollout and manage deployments for the microservices deployed in the cluster.
- Setup Kubernetes Dashboard to visualize deployments, pods, services, etc.

Side Note: K3D has been adopted for this POC but I left minikube commands commented out in case you want to try it out instead.

## Getting Started
To get started with this project, follow the steps below:

### Clone the Repository
~~~
git clone https://github.com/marcelocollyer/k8s-bootstrap
~~~
### Run Bootstrap Script
This should deploy versions v1 and v2 of the microservices to simulate a blue-green deployment. Traffic will be 50% - 50% for each microservice version stack.
It will open Kiali's dashboard after the execution which should open already authenticated. Keep eyes on the script output to see passwords and tokens for additional services like Kibana (optional).
~~~
chmod +x bootstrap.sh
./bootstrap.sh
~~~

## Observe microservices on Kiali - no communication so far
![alt text](images/kiali-initial-stage.png)

## Send Requests
- Open up a terminal
- Start sending requests to microservice-a
- Notice the alternated messages depending on each version of microservice-a gets hit first
~~~
while true;do curl http://localhost:8000;echo;sleep 1;done

Microservice A v1 -> Microservice B v1 -> Microservice C v1
Microservice A v2 -> Microservice B v2 -> Microservice C v2
~~~

## Contact Information
Marcelo Collyer </br>
marcelocollyer@gmail.com</br>
https://www.linkedin.com/in/marcelocollyer/</br>
Feel free to connect with me for collaborations or questions about this project.





