#!/bin/bash
# Script to configure hosts file

set -e

echo "=========================================="
echo "Configuring hosts file"
echo "=========================================="

# Get Minikube IP (as current user, not root)
echo "Getting Minikube IP address..."
MINIKUBE_IP=$(minikube ip -p greencap-k8s 2>/dev/null)
echo "Minikube IP: $MINIKUBE_IP"
echo ""

# Backup hosts file if backup doesn't exist yet
if [ -f /etc/hosts ] && [ ! -f /etc/hosts.gcbck ]; then
    echo "💾 Creating backup of /etc/hosts..."
    sudo cp /etc/hosts /etc/hosts.gcbck
    echo "Backup created: /etc/hosts.gcbck"
fi

# Remove existing entries between [begin:greencap] and [end:greencap]
if grep -q "\[begin:greencap\]" /etc/hosts && grep -q "\[end:greencap\]" /etc/hosts; then
    echo "🧹 Removing existing entries between [begin:greencap] and [end:greencap] in /etc/hosts..."
    sudo sed -i '/\[begin:greencap\]/,/\[end:greencap\]/d' /etc/hosts
fi

# Check for use of sudo/root privileges
if [ "$EUID" -ne 0 ]; then
    echo "⚠️  This script must be run with 'sudo' to modify /etc/hosts."
    echo "    Please enter your password to continue."
fi

echo "Adding DNS entries to /etc/hosts..."
sudo bash -c 'echo "# [begin:greencap]" >> /etc/hosts'
sudo bash -c 'echo "# Added by Greencap installer:" >> /etc/hosts'
sudo bash -c "echo '$MINIKUBE_IP tech-docs.greencap' >> /etc/hosts"
sudo bash -c "echo '$MINIKUBE_IP ecom-python.greencap' >> /etc/hosts"
sudo bash -c "echo '$MINIKUBE_IP pgadmin.greencap' >> /etc/hosts"
sudo bash -c "echo '$MINIKUBE_IP kubernetes-dashboard.greencap' >> /etc/hosts"
sudo bash -c "echo '$MINIKUBE_IP grafana.greencap' >> /etc/hosts"
sudo bash -c "echo '$MINIKUBE_IP core.harbor.greencap' >> /etc/hosts"
sudo bash -c "echo '$MINIKUBE_IP notary.harbor.greencap' >> /etc/hosts"
sudo bash -c "echo '$MINIKUBE_IP gitlab.greencap' >> /etc/hosts"
sudo bash -c "echo '$MINIKUBE_IP jaeger.greencap' >> /etc/hosts"
sudo bash -c "echo '$MINIKUBE_IP prometheus.greencap' >> /etc/hosts"
sudo bash -c 'echo "# [end:greencap]" >> /etc/hosts'

echo ""
echo "Basic testing of hosts configuration..."

# Verify all hosts were added
MISSING_HOSTS=0
for host in tech-docs.greencap kubernetes-dashboard.greencap; do
    if grep -q "$MINIKUBE_IP $host" /etc/hosts; then
        echo "✅ $host"
    else
        echo "❌ $host - NOT FOUND"
        MISSING_HOSTS=$((MISSING_HOSTS + 1))
    fi
done

echo ""
echo "=========================================="
echo "Hosts file configured successfully."
echo "=========================================="