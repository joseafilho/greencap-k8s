#!/bin/bash
# Script to install kubernetes dashboard

set -e

echo "=========================================="
echo "🔧 Installing kubernetes dashboard"
echo "=========================================="

minikube addons enable dashboard -p greencap-k8s
kubectl apply -f ./infra-code-manifests/kubernetes-dashboard/dash-ing.yaml

echo ""
echo "=========================================="
echo "✅ Kubernetes dashboard installed successfully!"
echo "=========================================="