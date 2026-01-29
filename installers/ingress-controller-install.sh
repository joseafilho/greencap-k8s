#!/bin/bash

set -e

echo "=========================================="
echo "Installing ingress controller"
echo "=========================================="

minikube addons enable ingress -p greencap-k8s
echo "==> Ingress controller installed successfully!"