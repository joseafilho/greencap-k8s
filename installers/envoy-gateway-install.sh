#!/bin/bash
# Script to install Envoy Gateway with Gateway API

set -e

GATEWAY_API_VERSION="v1.2.0"
ENVOY_GATEWAY_VERSION="v1.2.2"
GATEWAY_MANIFESTS_PATH="./infra-code-manifests/envoy-gateway"

echo "=========================================="
echo "Installing Envoy Gateway with Gateway API"
echo "=========================================="

# Install Gateway API CRDs
echo "Installing Gateway API CRDs ${GATEWAY_API_VERSION}..."
kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/${GATEWAY_API_VERSION}/standard-install.yaml

# Wait for CRDs to be established
echo "Waiting for Gateway API CRDs to be ready..."
sleep 10

# Install Envoy Gateway
echo "Installing Envoy Gateway ${ENVOY_GATEWAY_VERSION}..."
kubectl apply --server-side -f https://github.com/envoyproxy/gateway/releases/download/${ENVOY_GATEWAY_VERSION}/install.yaml

# Wait for Envoy Gateway to be ready
echo "Waiting for Envoy Gateway to be ready..."
kubectl wait --namespace envoy-gateway-system \
  --for=condition=available deployment/envoy-gateway \
  --timeout=300s

# Apply Gateway configuration
echo "Applying Gateway configuration..."
kubectl apply -f "${GATEWAY_MANIFESTS_PATH}/gateway.yaml"

# Wait for Gateway to be ready
echo "Waiting for Gateway to be programmed..."
kubectl wait --namespace envoy-gateway-system \
  --for=condition=programmed gateway/greencap-gateway \
  --timeout=300s

echo ""
echo "=========================================="
echo "Envoy Gateway installed successfully!"
echo "=========================================="
echo ""
echo "Gateway Details:"
kubectl get gateway -n envoy-gateway-system
echo ""
echo "Gateway Address:"
kubectl get gateway greencap-gateway -n envoy-gateway-system -o jsonpath='{.status.addresses[0].value}'
echo ""
echo "=========================================="
