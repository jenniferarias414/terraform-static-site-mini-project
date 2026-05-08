variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-2"
}

variable "project" {
  description = "Project name used for naming resources"
  type        = string
}

variable "environment" {
  description = "Environment name, such as dev, qa, or prod"
  type        = string
}

variable "owner" {
  description = "Owner name used for tagging and naming"
  type        = string
}
