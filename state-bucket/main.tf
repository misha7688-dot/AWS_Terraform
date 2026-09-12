terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tf-bk-shop-misha-2026"


  tags = {
    Name      = "Terraform State Bucket"
    Project   = "tf-shop"
    ManagedBy = "terraform"
  }
}
