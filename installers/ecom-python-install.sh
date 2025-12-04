#!/bin/bash
# Script to install ecom-python.

set -e

ECOM_PYTHON_DIR="./projects/ecom-python"

echo "=========================================="
echo "🔧 Installing ecom-python"
echo "=========================================="

echo "🔍 Creating namespace ecom-python..."
kubectl create namespace ecom-python

kubectl apply -f $ECOM_PYTHON_DIR/infra/create-db-job.yaml

# Add entries to /etc/hosts.
echo "📝 Adding entries to /etc/hosts..."
sudo bash -c 'echo "127.0.0.1 ecom-python.greencap" >> /etc/hosts'

# Build and load docker image.
echo "🚀 Building and loading docker image..."
docker build -t ecom-python-api:latest -f $ECOM_PYTHON_DIR/Dockerfile $ECOM_PYTHON_DIR
kind load docker-image ecom-python-api:latest --name greencap-k8s

# Deploy ecom-python.
echo "🚀 Deploying ecom-python..."
export POSTGRES_PASSWORD=$(kubectl get secret postgres-17 -n postgresql -o jsonpath="{.data.POSTGRES_PASSWORD}" | base64 -d)
envsubst < $ECOM_PYTHON_DIR/infra/deployment.yaml | kubectl apply -f -
kubectl apply -f $ECOM_PYTHON_DIR/infra/service.yaml
kubectl apply -f $ECOM_PYTHON_DIR/infra/route.yaml

echo ""
echo "=========================================="
echo "✅ Ecom-python installed successfully!"
echo "=========================================="