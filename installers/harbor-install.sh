#!/bin/bash
# Script to install harbor.

set -e

HARBOR_DIR="./helm-values/harbor"
HARBOR_MANIFESTS_DIR="./infra-code-manifests/harbor"

echo "=========================================="
echo "🔧 Installing Harbor"
echo "=========================================="

# Add entries to /etc/hosts.
echo "📝 Adding entries to /etc/hosts..."
sudo bash -c 'echo "127.0.0.1 core.harbor.greencap" >> /etc/hosts'
sudo bash -c 'echo "127.0.0.1 notary.harbor.greencap" >> /etc/hosts'

# Add harbor repository to helm.
echo "🔍 Adding harbor repository to helm..."
helm repo add harbor https://helm.goharbor.io
helm repo update

# Install harbor.
HARBOR_CHART_VERSION="1.18.0"
echo "🚀 Installing Harbor..."
kubectl create namespace harbor
helm install harbor harbor/harbor --version=${HARBOR_CHART_VERSION} --namespace harbor --values $HARBOR_DIR/values.yaml

# Apply Gateway API HTTPRoute manifests
echo "🌐 Applying Gateway API HTTPRoute manifests..."
kubectl apply -f $HARBOR_MANIFESTS_DIR/harbor-core-httproute.yaml
kubectl apply -f $HARBOR_MANIFESTS_DIR/harbor-notary-httproute.yaml

echo ""
echo "=========================================="
echo "✅ Harbor installed successfully!"
echo "📝 Access Harbor via Gateway API:"
echo "   - Core:  http://core.harbor.greencap:30001"
echo "   - Core:  https://core.harbor.greencap:30002"
echo "   - Notary: http://notary.harbor.greencap:30001"
echo "   - Notary: https://notary.harbor.greencap:30002"
echo "=========================================="