# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-cluster"
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  tags = {
    Name = "${var.project_name}-cluster"
  }
}
