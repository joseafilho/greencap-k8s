#!/bin/bash

set -e

KUBECTL_INSTALL_USER=$1

if [ -z "$KUBECTL_INSTALL_USER" ]; then
    echo "Erro: Parameter user to configure the kubectl not informed."
    echo "Example: ./configure-kubectl.sh ubuntu"
    exit 1
fi

echo "=========================================="
echo "Configuring kubectl"
echo "=========================================="

# Configure kubectl to use kind cluster
echo "Configuring kubectl..."
mkdir -p /home/$KUBECTL_INSTALL_USER/.kube/
sudo chown -R $KUBECTL_INSTALL_USER:$KUBECTL_INSTALL_USER /home/$KUBECTL_INSTALL_USER/.kube/
kind get kubeconfig --name greencap-k8s > /home/$KUBECTL_INSTALL_USER/.kube/config
ls -la /home/$KUBECTL_INSTALL_USER/.kube
echo "==> kubectl configured."

# Validate kubectl installation
echo "Validating kubectl installation..."
kubectl cluster-info
kubectl get nodes
echo "==> kubectl validation completed."
