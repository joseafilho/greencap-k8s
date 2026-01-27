[![pt-br](https://img.shields.io/badge/lang-pt--br-green.svg)](./docs/readme-translations/index/pt-br/README.md)

# GreenCap K8s

## Description

GreenCap is a project that provides a complete environment for Kubernetes studies, development and testing:

It is ideal for developers who need a complete playground to test Kubernetes applications including: container registry, database, monitoring, logs, ci/cd(gitlab) and much more.

Some tools that make up the platform:

- **Minikube**: Local Kubernetes cluster with VirtualBox driver
- **Ingress**: Nginx
- **Container Registry**: Harbor for Docker image management
- **Database**: PostgreSQL with pgAdmin interface
- **Sample Application**: FastAPI Python API connecting to PostgreSQL
- **Dashboard**: Kubernetes Dashboard for monitoring
- **Observability Stack**: Prometheus + Grafana + Jaeger for complete monitoring
- **Git**: GitLab
- **CI/CD**: GitLab

## Pre-requirements:

**For Minikube (default):**
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [VirtualBox](https://www.virtualbox.org/)

**For AWS deployment:**
- AWS Account with appropriate credentials
- Terraform installed

## How to Use:

1. **Clone the repository:**
   ```sh
   git clone git@github.com:greencapk8s/greencap-k8s.git
   cd greencap-k8s
   ```

2. **Start the environment:**

   - **Minikube (local Kubernetes cluster - default):**
     ```sh
     # With custom resources
     ./greencap.sh --minikube --minikube-memory 8192 --minikube-cpus 4
     
     # With default settings (4GB RAM, 2 CPUs)
     ./greencap.sh --minikube
     
     # Or simply (minikube is the default provider)
     ./greencap.sh
     
     # With full setup
     ./greencap.sh --minikube --setup-type full --minikube-memory 8192 --minikube-cpus 4
     ```
   
   - **AWS EC2 (via Terraform):**
     
     By default, terraform plan is executed:
     
     ```sh
     ./greencap.sh --aws --instance-type t3a.xlarge --region <region> --key-name <ec2-key-pair> --public-ip <your-public-ip> --ami-id <ubuntu-ami>
     ```

     To apply, add the parameter(`--auto-approve`) at the end of the command:

     ```sh
     ./greencap.sh --aws --instance-type t3a.xlarge --region <region> --key-name <ec2-key-pair> --public-ip <your-public-ip> --ami-id <ubuntu-ami> --auto-approve
     ```

## Installation Customization:

GreenCap supports three installation types via the `--setup-type` parameter:

- **minimal** (default): Installs only essential components (Minikube, kubectl, Helm, Ingress, and Kubernetes Dashboard)
- **full**: Installs all available components
- **custom**: Allows selective installation of additional components via `greencap.ini` configuration file

### Custom Installation:

To customize your installation, create a `greencap.ini` file from the provided example:

```sh
cp greecap.ini.example greencap.ini
```

Then edit `greencap.ini` to enable/disable components:

```ini
[installation]
monitoring=false   # Prometheus + Grafana
harbor=false       # Container Registry
gitlab=false       # Git & CI/CD
postgres=false     # PostgreSQL + pgAdmin
ecom-python=false  # Sample Python application
```

Set `true` for components you want to install, and `false` for those you don't.

**Usage with Minikube:**

```sh
./greencap.sh --minikube --setup-type custom --minikube-memory 8192 --minikube-cpus 4
```

> **Note:** The `greencap.ini` file is only used when `--setup-type custom` is specified. For AWS deployments, the configuration file must be manually transferred to the instance and the installation re-run with the custom setup type.

## GreenCap K8s TechDocs:

- **Access TechDocs:**
  1. After deploying the Minikube cluster, access: http://tech-docs.greencap:30001
     - You should see the GreenCap K8s TechDocs page.
     - ![TechDocs page](./images/techdocs-home.png)
     
## Environment Cleanup:

To completely remove/clean the created environment, use the `--clean` parameter:

#### **Minikube Environment**

```sh
./greencap.sh --clean --minikube
```

This command will delete the Minikube cluster and all associated resources.

#### **AWS Environment (Terraform/EC2)**

```sh
./greencap.sh --clean --aws
```

This command will execute Terraform destroy and remove provisioned AWS resources (instances, disks, etc).

## Homologated Environments:

The following table shows the operating systems and environments where GreenCap K8s has been tested and homologated:

| Operating System | Version/Distribution | Architecture | Status |
|-----------------|---------------------|--------------|---------|
| **Linux** | Ubuntu 24.04 LTS | x86_64 | ✅ Homologated |
| **Linux** | Ubuntu 22.04 LTS | x86_64 | ✅ Homologated |
| **Linux** | Debian Based | x86_64 | ⚠️ Pre-Homologated |
| **Linux** | RedHat Based | x86_64 | ❌ Not yet homologated |
| **macOS** | macOS Based | Intel/Apple Silicon | ❌ Not yet homologated |
| **macOS** | macOS Based | Serie M | ❌ Not yet homologated |
| **Windows** | WSL2 (Ubuntu 22.04, 24.04) | x86_64 | ❌ Not yet homologated |

> **Note:** For Windows users, it's recommended to use WSL2 (Windows Subsystem for Linux) or run via VirtualBox for better compatibility.


## References

- [Minikube - Local Kubernetes](https://minikube.sigs.k8s.io/)
- [Ingress Nginx Controller](https://kubernetes.github.io/ingress-nginx/)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [Postgres](https://www.postgresql.org/docs/)
- [pgAdmin](https://www.pgadmin.org/docs/)
- [Gitlab](https://docs.gitlab.com/)
- [mascosta](https://github.com/mascosta/docs/blob/main/kind-ingress-nginx/README.md)
