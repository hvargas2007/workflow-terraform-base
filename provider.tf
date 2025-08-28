terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "BUCKET_NAME"
    key            = "global/PROJECT_NAME/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # use_lockfile = true  # Requires Terraform 1.1+
  }
}

provider "aws" {
  region = var.aws_region
}