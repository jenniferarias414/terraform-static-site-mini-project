locals {
  # S3 bucket names must be globally unique across AWS.
  # Update project/environment/owner values in terraform.tfvars if this name is already taken.
  bucket_name = lower("${var.project}-${var.environment}-${var.owner}")

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}
