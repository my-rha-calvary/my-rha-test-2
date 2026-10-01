# main.tf
terraform {
  required_version = ">= 1.8.0"

  # 1. Required Providers Section
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # 2. Remote Backend Section
  # Stores the state file securely in an S3 bucket instead of local disk
  backend "s3" {
    bucket         = "berry-white" # Name of your existing state bucket
    key            = "states/s3-app/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "tofu-state-lock" # Optional: Used for state locking
  }
}

variable "environment" {
  type        = string
  description = "The target deployment environment (e.g., staging, production)"
}

resource "aws_s3_bucket" "app_bucket" {
  # Globally unique bucket name combined with your environment variable
  bucket = "my-app-${var.environment}-bucket"

  tags = {
    Name        = "App Bucket"
    Environment = var.environment
  }
}
