#!/bin/bash
set -e

USER_NAME=${1:-vagrant}
MINIKUBE_VERSION="latest"

echo "📦 Installing Minikube..."

# Download and install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Configure kubectl for user
sudo -u $USER_NAME mkdir -p /home/$USER_NAME/.kube
sudo chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.kube

echo "✅ Minikube installed successfully!"
minikube version
