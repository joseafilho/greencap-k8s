#!/bin/bash

set -e

GATEWAY_MANIFEST_PATH="./infra-code-manifests/gateway-api/gateway.yaml"
NGF_VERSION="v2.2.0"

echo "=========================================="
echo "Installing Gateway API Resources"
echo "=========================================="

# Install Gateway API resources (standard channel)
# This includes the base CRDs for Gateway API
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=${NGF_VERSION}" | kubectl apply -f -

echo "==> Gateway API resources installed successfully!"

echo "=========================================="
echo "Installing NGINX Gateway Fabric CRDs"
echo "=========================================="

# Install NGINX Gateway Fabric CRDs (v2.2.0 - latest stable)
# Using --server-side to avoid issues with large CRDs
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/${NGF_VERSION}/deploy/crds.yaml

echo "==> NGINX Gateway Fabric CRDs installed successfully!"

echo "=========================================="
echo "Deploying NGINX Gateway Fabric Controller"
echo "=========================================="

# Deploy NGINX Gateway Fabric with NGINX Open Source
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/${NGF_VERSION}/deploy/default/deploy.yaml

# Wait for the gateway controller to be ready
echo "Waiting for NGINX Gateway Fabric controller to be ready..."
kubectl wait --namespace nginx-gateway \
  --for=condition=available deployment/nginx-gateway \
  --timeout=180s

echo "==> NGINX Gateway Fabric deployed successfully!"

echo "=========================================="
echo "Generating TLS Certificate for Gateway"
echo "=========================================="

# Generate TLS certificate for HTTPS listener
CERT_NAME="greencap-tls-cert"
NAMESPACE="nginx-gateway"
DOMAIN="*.greencap"

# Check if certificate already exists
if kubectl get secret ${CERT_NAME} -n ${NAMESPACE} &>/dev/null; then
    echo "TLS certificate already exists, skipping generation..."
else
    echo "Generating self-signed TLS certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /tmp/tls.key \
      -out /tmp/tls.crt \
      -subj "/CN=${DOMAIN}/O=GreenCap K8s" \
      -addext "subjectAltName=DNS:*.greencap,DNS:greencap" 2>/dev/null

    # Create Secret in Kubernetes
    kubectl create secret tls ${CERT_NAME} \
      --cert=/tmp/tls.crt \
      --key=/tmp/tls.key \
      --namespace=${NAMESPACE}

    # Clean up temporary files
    rm -f /tmp/tls.key /tmp/tls.crt
    
    echo "==> TLS certificate created successfully!"
fi

echo "=========================================="
echo "Creating Gateway resource"
echo "=========================================="

# Apply the Gateway resource
kubectl apply -f "$GATEWAY_MANIFEST_PATH"

# Wait for Gateway to be ready
echo "Waiting for Gateway to be ready..."
kubectl wait --namespace nginx-gateway \
  --for=condition=Programmed gateway/greencap-gateway \
  --timeout=180s

echo "==> Gateway created and ready!"
echo ""
echo "Gateway API installation completed successfully!"
echo "You can now create HTTPRoute resources to route traffic."

