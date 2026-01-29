#!/bin/bash

set -e

# Default values
PROVIDER="minikube"
NODE_MEMORY=4096
NODE_CPUS=2
NODE_COUNTS=1
MINIKUBE_DRIVER="virtualbox"
AWS_INSTANCE_TYPE="t3a.medium"
AWS_REGION="us-east-1"
AWS_KEY_NAME=""
AWS_AMI_ID=""
AWS_SUBNET_ID=""
AWS_SECURITY_GROUP_ID=""
AWS_AUTO_APPROVE=false
AWS_PUBLIC_IP=""
USER_NAME_INSTALL=""
SETUP_TYPE="minimal"
CLEAN_MODE=false

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "GreenCap K8s - Kubernetes Development Environment"
    echo ""
    echo "Providers:"
    echo "  --minikube              Deploy locally using Minikube (default)"
    echo "  --aws                   Deploy to AWS EC2 via Terraform"
    echo ""
    echo "Minikube Options:"
    echo "  --node-memory           Memory in MB for each node (default: 4096 MB)"
    echo "  --node-cpus             Number of CPUs for each node (default: 2)"
    echo "  --node-counts           Number of nodes (default: 1)"
    echo "  --user-name             User name for installation (default: vagrant)"
    echo "  --setup-type            Setup type: minimal, full, or custom (default: minimal)"
    echo ""
    echo "AWS Options:"
    echo "  --instance-type         AWS instance type (default: t3a.medium)"
    echo "  --region                AWS region (default: us-east-1)"
    echo "  --key-name              AWS key pair name (required for AWS)"
    echo "  --ami-id                AWS AMI ID (optional)"
    echo "  --subnet-id             AWS subnet ID (optional)"
    echo "  --security-group        AWS security group ID (optional)"
    echo "  --public-ip             Your public IP address (required for AWS)"
    echo "  --auto-approve          Auto-approve terraform apply (default: false)"
    echo ""
    echo "General Options:"
    echo "  --help                  Show this help message"
    echo "  --clean                 Clean the environment"
    echo ""
    echo "Examples:"
    echo "  Minikube (local):"
    echo "    $0                             # Deploy with defaults"
    echo "    $0 --minikube --node-memory 8192 --node-cpus 4"
    echo "    $0 --minikube --setup-type full"
    echo ""
    echo "  AWS deployment:"
    echo "    $0 --aws --key-name my-key --public-ip 192.168.1.100"
    echo "    $0 --aws --instance-type t3a.xlarge --key-name my-key --public-ip X.X.X.X"
    echo ""
    echo "  Clean environments:"
    echo "    $0 --clean                    # Clean Minikube (default)"
    echo "    $0 --clean --aws              # Clean AWS environment"
}

# Function to validate AWS prerequisites
validate_aws_prerequisites() {
    echo "🔍 Validating AWS prerequisites..."

    # Check if AWS CLI is installed
    if ! command -v aws &> /dev/null; then
        echo "❌ AWS CLI not found. Please install it first:"
        echo "   https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
        exit 1
    fi

    # Check if Terraform is installed
    if ! command -v terraform &> /dev/null; then
        echo "❌ Terraform not found. Please install it first:"
        echo "   https://developer.hashicorp.com/terraform/downloads"
        exit 1
    fi

    # Check if key name is provided
    if [ -z "$AWS_KEY_NAME" ]; then
        echo "❌ AWS key name is required. Use --key-name option."
        exit 1
    fi

    # Warn about auto-approve if enabled
    if [ "$AWS_AUTO_APPROVE" = true ]; then
        echo "⚠️  WARNING: Auto-approve is enabled!"
        echo "   This will apply Terraform changes in AWS directly."
        echo "   Make sure you have reviewed the plan before proceeding."
        echo ""
        read -p "Press Enter to continue or Ctrl+C to cancel..."
    fi

    echo "✅ AWS prerequisites validated!"
}

# Function to validate Minikube prerequisites
validate_minikube_prerequisites() {
    echo "🔍 Validating Minikube prerequisites..."
    
    if ! command -v VBoxManage &> /dev/null; then
        echo "❌ VirtualBox not found. Please install it first."
        exit 1
    fi
    
    echo "✅ Minikube prerequisites validated!"
}

# Function to create Terraform configuration
create_terraform_config() {
    echo "📝 Creating Terraform configuration..."
    cd terraform

    # Build command with all parameters
    GENERATE_CMD="./play-terraform.sh \
        --instance-type \"$AWS_INSTANCE_TYPE\" \
        --region \"$AWS_REGION\" \
        --key-name \"$AWS_KEY_NAME\" \
        --volume-size 50"

    if [ -n "$AWS_AMI_ID" ]; then
        GENERATE_CMD="$GENERATE_CMD --ami-id \"$AWS_AMI_ID\""
    fi

    if [ -n "$AWS_SUBNET_ID" ]; then
        GENERATE_CMD="$GENERATE_CMD --subnet-id \"$AWS_SUBNET_ID\""
    fi

    if [ -n "$AWS_SECURITY_GROUP_ID" ]; then
        GENERATE_CMD="$GENERATE_CMD --security-group \"$AWS_SECURITY_GROUP_ID\""
    fi

    GENERATE_CMD="$GENERATE_CMD --public-ip \"$AWS_PUBLIC_IP\""

    # Execute the command
    eval $GENERATE_CMD

    cd ..

    echo "✅ Terraform configuration created!"
}

# Function to deploy to AWS
deploy_aws() {
    echo "🚀 Deploying to AWS EC2..."

    # Validate prerequisites
    validate_aws_prerequisites

    # Create Terraform configuration
    create_terraform_config

    # Initialize Terraform
    echo "🔧 Initializing Terraform..."
    cd terraform
    terraform init

    # Plan deployment
    echo "📋 Planning deployment..."
    terraform plan

    # Deploy
    echo "🚀 Deploying infrastructure..."
    if [ "$AWS_AUTO_APPROVE" = true ]; then
        echo "⚠️  Auto-approve enabled - applying changes without confirmation"
        terraform apply -auto-approve

        echo ""
        echo "=========================================="
        echo "✅ AWS deployment completed."
        echo "=========================================="
    else
        echo ""
        echo "=========================================="
        echo "✅ Terraform plan completed."
        echo "=========================================="
        echo ""
    fi

    cd ..
}

# Function to deploy Minikube
deploy_minikube() {
    echo "🚀 Deploying Minikube cluster..."
    
    validate_minikube_prerequisites
    
    # Install Minikube if not present
    if ! command -v minikube &> /dev/null; then
        echo "📦 Installing Minikube..."
        ./installers/minikube-install.sh "$USER_NAME_INSTALL"
    fi
    
    # Start Minikube cluster with greencap-k8s profile
    echo "🎯 Starting Minikube cluster 'greencap-k8s'..."
    minikube start \
        --profile=greencap-k8s \
        --driver="$MINIKUBE_DRIVER" \
        --memory="$NODE_MEMORY" \
        --cpus="$NODE_CPUS" \
        --nodes="$NODE_COUNTS" \
        --kubernetes-version=stable
    
    # Run installers
    PROVIDER="$PROVIDER" USER_NAME_INSTALL="$USER_NAME_INSTALL" SETUP_TYPE="$SETUP_TYPE" ./installers/run-installers.sh
    
    echo ""
    echo "=========================================="
    echo "✅ Minikube setup completed successfully!"
    echo "=========================================="
    echo "Cluster Profile: greencap-k8s"
    echo "Driver: $MINIKUBE_DRIVER"
    echo "Memory: ${NODE_MEMORY}MB"
    echo "CPUs: $NODE_CPUS"
    echo "Nodes: $NODE_COUNTS"
    echo "=========================================="
}

# Function to clean Minikube environment
clean_minikube() {
    echo "🗑️  Cleaning Minikube environment..."
    
    if command -v minikube &> /dev/null; then
        minikube delete --profile=greencap-k8s || true
        echo "Minikube cluster 'greencap-k8s' deleted successfully."
    else
        echo "⚠️  Minikube not installed. Nothing to clean."
    fi
    
    echo ""
    echo "=========================================="
    echo "Minikube environment cleaned successfully."
    echo "=========================================="
}

# Function to clean environment
clean_environment() {
    echo "=========================================="
    echo "🧹 Cleaning Environment"
    echo "=========================================="

    if [ "$PROVIDER" = "aws" ]; then
        echo "Provider: AWS"
        clean_aws
    elif [ "$PROVIDER" = "minikube" ]; then
        echo "Provider: Minikube"
        clean_minikube
    else
        echo "❌ Unknown provider: $PROVIDER"
        echo "Valid providers: aws, minikube"
        exit 1
    fi
}


# Function to clean AWS environment
clean_aws() {
    echo "🗑️  Cleaning AWS environment..."

    cd terraform

    if [ ! -f "terraform.tfstate" ] || [ ! -s "terraform.tfstate" ]; then
        echo "⚠️  No Terraform state found. No AWS resources to destroy."
        cd ..
        return
    fi

    echo "🔧 Initializing Terraform..."
    terraform init

    echo "📋 Planning destruction..."
    terraform plan -destroy

    echo ""
    echo "⚠️  WARNING: This will destroy all AWS resources created by Terraform!"
    echo "   This action cannot be undone."
    echo ""

    if [ "$AWS_AUTO_APPROVE" = true ]; then
        echo "⚠️  Auto-approve enabled - destroying resources without confirmation"
        terraform destroy -auto-approve
    else
        read -p "Are you sure you want to destroy the AWS environment? (yes/no): " -r
        echo
        if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
            terraform destroy
        else
            echo "❌ Destruction cancelled."
            cd ..
            exit 0
        fi
    fi

    cd ..

    echo ""
    echo "=========================================="
    echo "AWS environment cleaned successfully."
    echo "=========================================="
}


# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --minikube)
            PROVIDER="minikube"
            shift
            ;;
        --node-memory)
            NODE_MEMORY="$2"
            shift 2
            ;;
        --node-cpus)
            NODE_CPUS="$2"
            shift 2
            ;;
        --node-counts)
            NODE_COUNTS="$2"
            shift 2
            ;;
        --aws)
            PROVIDER="aws"
            shift
            ;;
        --user-name)
            USER_NAME_INSTALL="$2"
            shift 2
            ;;
        --setup-type)
            SETUP_TYPE="$2"
            shift 2
            ;;
        --instance-type)
            AWS_INSTANCE_TYPE="$2"
            shift 2
            ;;
        --region)
            AWS_REGION="$2"
            shift 2
            ;;
        --key-name)
            AWS_KEY_NAME="$2"
            shift 2
            ;;
        --ami-id)
            AWS_AMI_ID="$2"
            shift 2
            ;;
        --subnet-id)
            AWS_SUBNET_ID="$2"
            shift 2
            ;;
        --security-group)
            AWS_SECURITY_GROUP_ID="$2"
            shift 2
            ;;
        --public-ip)
            AWS_PUBLIC_IP="$2"
            shift 2
            ;;
        --auto-approve)
            AWS_AUTO_APPROVE=true
            shift
            ;;
        --clean)
            CLEAN_MODE=true
            shift
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if we're in clean mode
if [ "$CLEAN_MODE" = true ]; then
    clean_environment
    exit 0
fi

# Validate required parameters
if [ "$PROVIDER" = "aws" ]; then
    if [ -z "$AWS_KEY_NAME" ]; then
        echo "❌ Error: AWS key name is required. Use --key-name option."
        show_usage
        exit 1
    fi

    if [ -z "$AWS_PUBLIC_IP" ]; then
        echo "❌ Error: Your public IP address is required for AWS deployment."
        echo "   This IP will be used to allow your access to the AWS instance."
        echo "   Use --public-ip option to provide your public IP address."
        show_usage
        exit 1
    fi
elif [ "$PROVIDER" = "minikube" ]; then
    # Validate setup type
    if [[ ! "$SETUP_TYPE" =~ ^(minimal|full|custom)$ ]]; then
        echo "❌ Error: Invalid setup type '$SETUP_TYPE'. Must be one of: minimal, full, custom"
        show_usage
        exit 1
    fi
fi

echo "=========================================="
echo "Creating Environment"
echo "=========================================="
echo "Provider: $PROVIDER"
if [ "$PROVIDER" = "aws" ]; then
    echo "Instance Type: $AWS_INSTANCE_TYPE"
    echo "Region: $AWS_REGION"
    echo "Key Name: $AWS_KEY_NAME"
    echo "Auto-approve: $([ "$AWS_AUTO_APPROVE" = true ] && echo "Enabled" || echo "Disabled")"
    if [ -n "$AWS_AMI_ID" ]; then
        echo "AMI ID: $AWS_AMI_ID"
    fi
    echo "Your Public IP: $AWS_PUBLIC_IP"
elif [ "$PROVIDER" = "minikube" ]; then
    echo "Driver: $MINIKUBE_DRIVER"
    echo "Memory: ${NODE_MEMORY}MB"
    echo "CPUs: $NODE_CPUS"
    echo "Nodes: $NODE_COUNTS"
    echo "User Name: $USER_NAME_INSTALL"
fi
echo "Setup Type: $SETUP_TYPE"
echo "=========================================="

if [ "$PROVIDER" = "aws" ]; then
    deploy_aws
else
    deploy_minikube
fi