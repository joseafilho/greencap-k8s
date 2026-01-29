#!/bin/bash
# Script to install TechDocs (MkDocs)

set -e

TECH_DOCS_DIR="./projects/tech-docs"

echo "=========================================="
echo "📚 TechDocs Installation (MkDocs)"
echo "=========================================="

# Create namespace
echo "Creating tech-docs namespace..."
kubectl create namespace tech-docs --dry-run=client -o yaml | kubectl apply -f -

# Build and load docker image
echo "Building and loading docker image..."
docker build -t tech-docs:latest -f $TECH_DOCS_DIR/Dockerfile $TECH_DOCS_DIR
minikube image load tech-docs:latest -p greencap-k8s

# Deploy TechDocs
echo "Deploying TechDocs..."
kubectl apply -f $TECH_DOCS_DIR/infra/deployment.yaml
kubectl apply -f $TECH_DOCS_DIR/infra/service.yaml
kubectl apply -f $TECH_DOCS_DIR/infra/ingress.yaml

# Wait for pods to be ready
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=tech-docs -n tech-docs --timeout=300s

# Check installation status
echo "Checking installation status..."
kubectl get pods -n tech-docs

echo ""
echo "=========================================="
echo "✅ TechDocs installed successfully!"
echo "=========================================="
echo ""
echo "🌐 Access URL:"
echo "  - TechDocs: http://tech-docs.greencap"
echo ""
echo "=========================================="

