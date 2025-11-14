output "instance_id" {
  description = "VPN instance ID"
  value       = aws_instance.vpn.id
}

output "instance_public_ip" {
  description = "VPN instance public IP"
  value       = aws_instance.vpn.public_ip
}

output "instance_private_ip" {
  description = "VPN instance private IP"
  value       = aws_instance.vpn.private_ip
}

output "security_group_id" {
  description = "VPN security group ID"
  value       = aws_security_group.vpn.id
}
