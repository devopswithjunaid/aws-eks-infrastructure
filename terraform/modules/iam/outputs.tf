output "user1_name" {
  description = "User1 IAM user name"
  value       = aws_iam_user.user1.name
}

output "user2_name" {
  description = "User2 IAM user name"
  value       = aws_iam_user.user2.name
}

output "eks_cluster_role_arn" {
  description = "EKS cluster role ARN"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_nodes_role_arn" {
  description = "EKS nodes role ARN"
  value       = aws_iam_role.eks_nodes_role.arn
}
