#!/bin/bash
# Script to install Kind

set -e

echo "=========================================="
echo "Installing Kind"
echo "=========================================="

# Install kind
KIND_VERSION="v0.29.0"
echo "📦 Installing Kind..."
curl -Lo ./kind https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind --version
echo "==> Kind installed."
