#!/bin/bash
# Script to generate self-signed TLS certificate for the Gateway
# This enables HTTPS on the frontend (Client → Gateway)

set -e

CERT_NAME="greencap-tls-cert"
NAMESPACE="nginx-gateway"
DOMAIN="*.greencap"

echo "=========================================="
echo "Generating self-signed TLS certificate"
echo "=========================================="

# Generate certificate and private key
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key \
  -out /tmp/tls.crt \
  -subj "/CN=${DOMAIN}/O=GreenCap K8s" \
  -addext "subjectAltName=DNS:*.greencap,DNS:greencap"

echo "Certificate generated successfully!"

# Create Secret in Kubernetes
kubectl create secret tls ${CERT_NAME} \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key \
  --namespace=${NAMESPACE} \
  --dry-run=client -o yaml | kubectl apply -f -

# Clean up temporary files
rm -f /tmp/tls.key /tmp/tls.crt

echo ""
echo "=========================================="
echo "TLS certificate created successfully."
echo "=========================================="
echo ""
echo "Secret name: ${CERT_NAME}"
echo "Namespace: ${NAMESPACE}"
echo ""
echo "NOTE: This is a self-signed certificate."
echo "Browsers will show security warnings."
echo "For production, use Let's Encrypt or cert-manager."


