terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

# IAM Module - Create users first
module "iam" {
  source = "./modules/iam"
  
  project_name = var.project_name
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  project_name          = var.project_name
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  availability_zones    = slice(data.aws_availability_zones.available.names, 0, 2)
}

# EKS Cluster Module
module "eks_cluster" {
  source = "./modules/eks_cluster"
  
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  cluster_role_arn   = module.iam.eks_cluster_role_arn
  kubernetes_version = var.kubernetes_version
  
  depends_on = [module.vpc, module.iam]
}

# Node Group Module
module "node_group" {
  source = "./modules/node_group"
  
  project_name      = var.project_name
  cluster_name      = module.eks_cluster.cluster_name
  private_subnet_ids = module.vpc.private_subnet_ids
  nodes_role_arn    = module.iam.eks_nodes_role_arn
  
  depends_on = [module.eks_cluster]
}

# VPN Module
module "vpn" {
  source = "../vpn"
  
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
  key_name         = var.key_name
  
  depends_on = [module.vpc]
}
