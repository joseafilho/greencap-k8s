# What is GreenCap K8s?

Welcome to **GreenCap K8s Technical Documentation**.

GreenCap K8s is a comprehensive Kubernetes platform that includes a complete ecosystem of tools and services for modern application development and deployment.

## Platform Overview

GreenCap K8s runs on **Minikube** with **VirtualBox** as the virtualization driver, providing a local Kubernetes environment that closely mimics production setups while remaining lightweight and developer-friendly.

### Key Features

- **Minikube-based**: Leverages Minikube's native addons for optimized performance
- **VirtualBox Driver**: Provides isolated VM environment for Kubernetes
- **Ingress-native**: Uses Minikube's built-in NGINX Ingress Controller addon
- **Easy Access**: Services accessible via standard HTTP ports through Ingress routing

### Platform Components

!!! success "Core Services"
    - **Kubernetes Dashboard**: Dashboard is a web-based Kubernetes user interface (via Minikube addon)
    - **Monitoring Stack**: Prometheus + Grafana for metrics and visualization
    - **Container Registry**: Harbor for secure container image storage
    - **CI/CD**: GitLab for continuous integration and deployment
    - **Database**: PostgreSQL for persistent data storage
    - **Ingress**: NGINX Ingress Controller (via Minikube addon)
    - **Metrics Server**: Resource metrics collection (via Minikube addon)

## Quick Links

- [Components Overview](components/overview.md)
- [Kubernetes Dashboard](components/kubernetes-dashboard.md)
- [Monitoring Setup](components/monitoring.md)
- [Harbor Registry](components/harbor.md)
- [GitLab CI/CD](components/gitlab.md)

## Prerequisites

Before using GreenCap K8s, ensure you have the following installed:

- **VirtualBox**: Required as the virtualization driver for Minikube
- **Minikube**: Kubernetes cluster management tool
- **kubectl**: Kubernetes command-line tool

!!! tip "Automated Setup"
    GreenCap K8s includes automated installation scripts that handle all prerequisites and configuration for you.

## Resource Requirements

### Minimum Requirements

- **CPU**: 2-4 cores
- **RAM**: 8 GB
- **Disk Space**: 20 GB free

### Recommended Requirements

- **CPU**: 4-8 cores
- **RAM**: 16 GB
- **Disk Space**: 40 GB free

!!! info "Minikube Configuration"
    GreenCap K8s is configured to use 4 CPUs and 8 GB RAM by default. These values can be adjusted based on your system resources.

---

!!! info "Stay Updated"
    This documentation is continuously updated. Check back regularly for new content and improvements!

