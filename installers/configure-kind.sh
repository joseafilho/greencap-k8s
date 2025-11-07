#!/bin/bash
# Script to configure Kind and create cluster

set -e

KIND_INSTALL_USER=$1

if [ -z "$KIND_INSTALL_USER" ]; then
    echo "Erro: Parameter user to install the kind not informed."
    echo "Example: ./kind-install.sh ubuntu"
    exit 1
fi

# Create kind configuration file
echo "📝 Creating Kind configuration file..."
cat > kind-config.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: cluster1
nodes:
- role: control-plane
  extraPortMappings: # Ports to be exposed from the cluster
  - containerPort: 30001
    hostPort: 30001
  - containerPort: 30002
    hostPort: 30002
- role: worker
- role: worker
networking:
  disableDefaultCNI: true # Disable the default CNI plugin
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.245.0.0/16"
EOF
sudo chown $KIND_INSTALL_USER:$KIND_INSTALL_USER kind-config.yaml
echo "Kind configuration file created."

# Create cluster
echo "🚀 Creating Kind cluster..."
kind create cluster --name greencap-k8s --config kind-config.yaml
echo "Kind cluster created successfully."

echo ""
echo "=========================================="
echo "Kind configured and cluster created."
echo "=========================================="
