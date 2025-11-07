#!/bin/bash

set -e

# [begin] Minimal setup.

# Check if we should use pre-installed tools
if [ "$USE_PRE_INSTALLED_TOOLS" = "true" ]; then
    echo "=========================================="
    echo "Using pre-installed tools (Docker, Kind, kubectl)"
    echo "=========================================="

    # Verify required tools are available
    echo "🔍 Verifying pre-installed tools..."

    if ! command -v docker &> /dev/null; then
        echo "❌ Error: Docker is not installed or not in PATH"
        exit 1
    fi
    echo "✅ Docker found: $(docker --version)"

    if ! command -v kind &> /dev/null; then
        echo "❌ Error: Kind is not installed or not in PATH"
        exit 1
    fi
    echo "✅ Kind found: $(kind --version)"

    if ! command -v kubectl &> /dev/null; then
        echo "❌ Error: kubectl is not installed or not in PATH"
        exit 1
    fi
    echo "✅ kubectl found: $(kubectl version --client --short 2>/dev/null || kubectl version --client)"

    echo ""
    echo "All required tools are available!"
    echo "Skipping installation of Docker, Kind, and kubectl"
    echo "=========================================="
else
    ./installers/kind-install.sh
    ./installers/kubectl-install.sh
fi

./installers/configure-kind.sh $USER_NAME_INSTALL
./installers/configure-kubectl.sh $USER_NAME_INSTALL
./installers/configure-docker-daemon.sh
./installers/configure-hosts.sh
./installers/helm-install.sh
./installers/cilium-install.sh
./installers/kubectl-top-install.sh
./installers/ingress-controller-install.sh
./installers/kube-dash-install.sh
./installers/tech-docs-install.sh
# [end] Minimal setup.

if [ -f ./greencap.ini ]; then
    echo "Reading greencap.ini file..."
    MONITORING_INSTALL=$(grep '^monitoring=' ./greencap.ini | cut -d'=' -f2)
    HARBOR_INSTALL=$(grep '^harbor=' ./greencap.ini | cut -d'=' -f2)
    GITLAB_INSTALL=$(grep '^gitlab=' ./greencap.ini | cut -d'=' -f2)
    POSTGRES_INSTALL=$(grep '^postgres=' ./greencap.ini | cut -d'=' -f2)
    ECOM_PYTHON_INSTALL=$(grep '^ecom-python=' ./greencap.ini | cut -d'=' -f2)
fi

if [[ "$SETUP_TYPE" == "full" ]] || [[ "$SETUP_TYPE" == "custom" && "$MONITORING_INSTALL" == "true" ]]; then
    ./installers/monitoring-install.sh
fi

if [[ "$SETUP_TYPE" == "full" ]] || [[ "$SETUP_TYPE" == "custom" && "$HARBOR_INSTALL" == "true" ]]; then
    ./installers/harbor-install.sh
fi

if [[ "$SETUP_TYPE" == "full" ]] || [[ "$SETUP_TYPE" == "custom" && "$GITLAB_INSTALL" == "true" ]]; then
    ./installers/gitlab-install.sh
fi

if [[ "$SETUP_TYPE" == "full" ]] || [[ "$SETUP_TYPE" == "custom" && "$POSTGRES_INSTALL" == "true" ]]; then
    ./installers/postgres-install.sh
fi

if [[ "$SETUP_TYPE" == "full" ]] || [[ "$SETUP_TYPE" == "custom" && "$ECOM_PYTHON_INSTALL" == "true" ]]; then
    ./installers/ecom-python-install.sh
fi

USER_NAME_INSTALL="$USER_NAME_INSTALL" ./installers/configure-shortcuts.sh
