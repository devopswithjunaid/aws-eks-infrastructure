#!/bin/bash

# Variables - Update these with your values
BUCKET_NAME="your-terraform-state-bucket"
REGION="us-west-2"

echo "Creating S3 bucket for Terraform state..."
aws s3 mb s3://$BUCKET_NAME --region $REGION

echo "Enabling versioning..."
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

echo "Creating backend.tf..."
cat > terraform/backend.tf << EOF
terraform {
  backend "s3" {
    bucket = "$BUCKET_NAME"
    key    = "terraform.tfstate"
    region = "$REGION"
  }
}
EOF

echo "Copy terraform.tfvars.example to terraform.tfvars and update values"
cp terraform/terraform.tfvars.example terraform/terraform.tfvars

echo "Please update terraform/terraform.tfvars with your values before running:"
echo "cd terraform"
echo "terraform init"
echo "terraform plan"
echo "terraform apply"
