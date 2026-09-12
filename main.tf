locals {
  name_prefix   = "${var.project}-${terraform.workspace}"
  instance_type = terraform.workspace == "prod" ? "t3.small" : "t3.micro"
  common_tags = {
    Project   = var.project
    Env       = terraform.workspace
    ManagedBy = "terraform"
  }
}

module "network" {
  source   = "./modules/network"
  project  = var.project
  region   = var.region
  vpc_cidr = var.vpc_cidr
  subnets  = var.subnets
  tags     = local.common_tags
}

terraform {
  /*  backend "s3" {
    bucket       = "tf-state-khetahurov-2026"
    key          = "shop/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
*/
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  cloud {
    organization = "Open5151"
    workspaces {
      tags = ["shop"] # воркспейси з цим тегом
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "assets" {
  bucket = "tf-shop-assets-bucket"
  tags = {
    Name      = "tf-shop byka"
    ManagedBy = "terraform"
    Owner     = "Mikhail"
  }
}
