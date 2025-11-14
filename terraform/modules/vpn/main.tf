# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group for VPN Server
resource "aws_security_group" "vpn" {
  name        = "${var.project_name}-vpn-sg"
  description = "Security group for VPN server"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # OpenVPN port
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP for Nginx proxy
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS for Nginx proxy
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-vpn-sg"
  }
}

# VPN Server Instance
resource "aws_instance" "vpn" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.vpn.id]
  subnet_id              = var.public_subnet_id

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
              
              # Create basic nginx config for proxy
              cat > /etc/nginx/sites-available/default << 'EOL'
              server {
                  listen 80 default_server;
                  listen [::]:80 default_server;
                  
                  server_name _;
                  
                  location / {
                      return 200 'VPN Server Ready - Configure OpenVPN and Nginx proxy manually';
                      add_header Content-Type text/plain;
                  }
              }
              EOL
              
              systemctl reload nginx
              EOF

  tags = {
    Name = "${var.project_name}-vpn-server"
  }
}
