#!/bin/bash

set -e

echo "=========================================="
echo "Installing kubectl top"
echo "=========================================="

minikube addons enable metrics-server -p greencap-k8s
echo "==> metrics-server installed successfully!"
