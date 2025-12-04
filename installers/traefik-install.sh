#!/bin/bash
# Script to install Traefik and Gateway API

set -e

echo "=========================================="
echo "🔧 Installing Traefik & Gateway API"
echo "=========================================="

# Install Gateway API CRDs
echo "📄 Installing Gateway API CRDs..."
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml

# Install Traefik
echo "🚀 Installing Traefik via Helm..."
helm repo add traefik https://traefik.github.io/charts
helm repo update

# Configure Traefik:
# - Enable Gateway API
# - Set NodePorts for external access
# - Allow insecure backend (for Dashboard self-signed certs)
helm upgrade --install traefik traefik/traefik \
    --namespace traefik --create-namespace \
    --set providers.kubernetesGateway.enabled=true \
    --set ports.web.nodePort=30001 \
    --set ports.websecure.nodePort=30002 \
    --set service.type=NodePort \
    --set "additionalArguments={--serversTransport.insecureSkipVerify=true}" \
    --wait

# Generate Self-Signed Certificate
echo "🔒 Generating Self-Signed Certificate for *.greencap..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout greencap.key -out greencap.crt \
    -subj "/CN=*.greencap/O=GreenCap/C=US" \
    -addext "subjectAltName = DNS:*.greencap" 2>/dev/null

echo "💾 Creating TLS Secret..."
kubectl create secret tls greencap-tls --cert=greencap.crt --key=greencap.key --namespace default --dry-run=client -o yaml | kubectl apply -f -
rm greencap.key greencap.crt

# Apply Gateway Configuration
echo "🌐 Applying Gateway Configuration..."
kubectl apply -f infra-code-manifests/gateway/gateway.yaml

echo ""
echo "=========================================="
echo "✅ Traefik installed successfully!"
echo "=========================================="
