# AWS EKS Infrastructure with Terraform

This project creates a complete AWS infrastructure setup with EKS cluster, VPN server, and Jenkins deployment using Terraform.

## 🏗️ Architecture

- **VPC**: Custom VPC with 2 public and 2 private subnets
- **EKS Cluster**: Kubernetes cluster in private subnets
- **Node Group**: 2 nodes (t3.small) for application deployment
- **VPN Server**: EC2 instance in public subnet for OpenVPN and Nginx proxy
- **IAM**: Users and roles for EKS management

## 📋 Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform installed (>= 1.0)
3. kubectl installed for EKS management
4. SSH key pair for EC2 access

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone <your-repo-url>
cd aws-eks-infrastructure
```

### 2. Configure Variables

```bash
# Copy example files
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
cp terraform/backend.tf.example terraform/backend.tf

# Edit with your values
nano terraform/terraform.tfvars
nano terraform/backend.tf
```

### 3. Deploy Infrastructure

```bash
# Run setup script (creates S3 bucket for state)
chmod +x setup-and-deploy.sh
./setup-and-deploy.sh

# Or deploy manually
cd terraform
terraform init
terraform plan
terraform apply
```

## 📁 Project Structure

```
├── terraform/
│   ├── modules/
│   │   ├── vpc/          # VPC and networking
│   │   ├── iam/          # IAM users and roles
│   │   ├── eks_cluster/  # EKS cluster
│   │   └── node_group/   # EKS worker nodes
│   ├── main.tf           # Main configuration
│   ├── variables.tf      # Input variables
│   └── outputs.tf        # Output values
├── vpn/                  # VPN server module
├── jenkins-deployment.yaml       # Jenkins K8s deployment
├── jenkins-nodeport-service.yaml # Jenkins NodePort service
├── nginx-jenkins-proxy.conf      # Nginx proxy configuration
└── setup-and-deploy.sh          # Automated setup script
```

## ⚙️ Configuration

### Variables (terraform.tfvars)
```hcl
aws_region = "us-west-2"
project_name = "your-project-name"
kubernetes_version = "1.28"
key_name = "your-keypair-name"
```

### Backend (backend.tf)
```hcl
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
```

## 🔧 Post-Deployment Setup

### 1. Configure kubectl for EKS
```bash
aws eks update-kubeconfig --region us-west-2 --name <cluster-name>
```

### 2. Deploy Jenkins
```bash
kubectl create namespace jenkins
kubectl apply -f jenkins-deployment.yaml
kubectl apply -f jenkins-nodeport-service.yaml
```

### 3. Configure VPN Server
```bash
# SSH to VPN server
ssh -i your-keypair.pem ubuntu@<VPN_SERVER_IP>

# Install OpenVPN
sudo apt update
sudo apt install openvpn easy-rsa -y
```

### 4. Setup Nginx Proxy
```bash
# Update nginx config with Jenkins LoadBalancer endpoint
sudo cp nginx-jenkins-proxy.conf /etc/nginx/sites-available/default
sudo systemctl reload nginx
```

## 🌐 Access Pattern

1. **Connect to VPN** → OpenVPN client
2. **Access Jenkins** → VPN → Nginx Proxy → Jenkins LoadBalancer
3. **Deploy Applications** → Jenkins → EKS Cluster
4. **Manage Infrastructure** → kubectl through VPN

## 💰 Cost Estimation

- **EKS Control Plane**: ~$73/month
- **NAT Gateway**: ~$32/month
- **EC2 Instances**: ~$38/month (VPN + 2 nodes)
- **Total**: ~$143/month

## 🧹 Cleanup

```bash
cd terraform
terraform destroy
```

## 🔒 Security Features

- EKS cluster in private subnets
- VPN-only access to internal resources
- Security groups with minimal required ports
- IAM roles with least privilege access

## 📊 Monitoring

- CloudWatch logs for EKS cluster
- VPC Flow Logs for network monitoring
- Jenkins build logs and metrics

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:
1. Check the documentation
2. Review Terraform logs
3. Open an issue in this repository

---

**⚠️ Important**: Always review and customize the configuration before deploying to production!
