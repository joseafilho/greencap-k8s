#!/bin/bash
# Script to install kubernetes dashboard

set -e

echo "=========================================="
echo "🔧 Installing kubernetes dashboard"
echo "=========================================="

echo "📝 Adding entries to /etc/hosts..."
sudo bash -c 'echo "127.0.0.1 kubernetes-dashboard.greencap" >> /etc/hosts'

kubectl apply -f ./infra-code-manifests/kubernetes-dashboard/kube-dash.yaml
kubectl apply -f ./infra-code-manifests/kubernetes-dashboard/dash-admin.yaml
kubectl -n kubernetes-dashboard create token admin-user; echo

# Using Gateway API HTTPRoute with HTTPS proxy (best practice solution)
echo "Deploying Dashboard HTTP→HTTPS proxy..."
kubectl apply -f ./infra-code-manifests/kubernetes-dashboard/dashboard-proxy.yaml
kubectl wait --for=condition=ready pod -l app=dashboard-proxy -n kubernetes-dashboard --timeout=60s

echo "Deploying HTTPRoute..."
kubectl apply -f ./infra-code-manifests/kubernetes-dashboard/dash-httproute.yaml

echo "*************************"
echo "==> Token to access kubernetes dashboard."
echo "*************************"

if [ -f ./infra-code-manifests/kubernetes-dashboard/dash-token ]; then
    rm ./infra-code-manifests/kubernetes-dashboard/dash-token
fi

kubectl describe secrets admin-user -n kubernetes-dashboard >> ./infra-code-manifests/kubernetes-dashboard/dash-token; echo
cat ./infra-code-manifests/kubernetes-dashboard/dash-token; echo
echo "*************************"

echo ""
echo "=========================================="
echo "✅ Kubernetes dashboard installed successfully!"
echo "=========================================="