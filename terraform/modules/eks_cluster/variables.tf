variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "EKS cluster role ARN"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}
