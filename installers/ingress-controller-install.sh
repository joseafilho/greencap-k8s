#!/bin/bash

set -e

echo "=========================================="
echo "Installing ingress controller"
echo "=========================================="

minikube addons enable ingress -p greencap-k8s

echo "Waiting for ingress-nginx webhook to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
sleep 5

echo "==> Ingress controller installed successfully!"