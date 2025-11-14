# EKS Node Group - Free Tier Optimized
resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.project_name}-nodes"
  node_role_arn   = var.nodes_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = ["t3.small"]
  disk_size       = 50  # Increased from default 20GB to 50GB

  scaling_config {
    desired_size = 2  # Updated to 2 nodes
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "${var.project_name}-node-group"
  }
}
