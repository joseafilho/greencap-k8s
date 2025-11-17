#!/bin/bash

set -e

# ⚠️  DEPRECATED: Ingress NGINX is being retired (March 2026)
# This script is kept for reference only.
# Use gateway-api-install.sh instead for new installations.
# Reference: https://www.kubernetes.dev/blog/2025/11/12/ingress-nginx-retirement/

INGRESS_PATH="./infra-code-manifests/ingress-nginx/ingress.yaml"

echo "=========================================="
echo "⚠️  WARNING: Installing DEPRECATED Ingress NGINX"
echo "Ingress NGINX will be retired in March 2026"
echo "Consider using Gateway API instead"
echo "=========================================="

kubectl apply -f "$INGRESS_PATH"
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

echo "==> Ingress controller installed successfully!"