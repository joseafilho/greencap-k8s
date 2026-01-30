#!/bin/bash
# Script to install kubernetes dashboard

set -e

echo "=========================================="
echo "🔧 Installing kubernetes dashboard"
echo "=========================================="

minikube addons enable dashboard -p greencap-k8s

echo "Waiting for dashboard to be ready..."
while ! kubectl get pods -n kubernetes-dashboard | grep -q "Running"; do
    sleep 1
done

echo "Dashboard is ready!"
kubectl apply -f ./infra-code-manifests/kubernetes-dashboard/dash-ing.yaml

echo ""
echo "=========================================="
echo "✅ Kubernetes dashboard installed successfully!"
echo "=========================================="