#!/bin/bash

set -e

KUBECTL_INSTALL_USER=$1

# Se a variável estiver vazia, usar o usuário atual
if [ -z "$KUBECTL_INSTALL_USER" ]; then
    KUBECTL_INSTALL_USER=$(whoami)
    echo "User parameter not provided. Using current user: $KUBECTL_INSTALL_USER"
fi

echo "=========================================="
echo "Installing kubectl and Configuring for Kind Cluster"
echo "=========================================="

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version
echo "==> kubectl installed successfully!"

# Configure kubectl to use kind cluster
echo "Configuring kubectl to use Kind cluster..."
mkdir -p /home/$KUBECTL_INSTALL_USER/.kube/
sudo chown -R $KUBECTL_INSTALL_USER:$KUBECTL_INSTALL_USER /home/$KUBECTL_INSTALL_USER/.kube/
kind get kubeconfig --name greencap-k8s > /home/$KUBECTL_INSTALL_USER/.kube/config
ls -la /home/$KUBECTL_INSTALL_USER/.kube
echo "==> kubectl configured for Kind cluster!"

# Validate kubectl installation
echo "Validating kubectl installation..."
kubectl cluster-info
kubectl get nodes
echo "==> kubectl validation completed!"
echo "==> kubectl installation and configuration completed!"
