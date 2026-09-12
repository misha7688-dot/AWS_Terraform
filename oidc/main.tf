terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1" # Вкажіть ваш регіон
}

# 1. OIDC Provider для app.terraform.io
resource "aws_iam_openid_connect_provider" "tfc" {
  url             = "https://app.terraform.io"
  client_id_list  = ["aws.workload.identity"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}

# 2. Політика довіри (Trust Policy)
data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.tfc.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    }

    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      # Замініть YOUR_ORG на назву вашої організації в HCP Terraform
      values   = ["organization:Open5151:project:*:workspace:*:run_phase:*"]
    }
  }
}

# 3. IAM Роль
resource "aws_iam_role" "tfc" {
  name               = "tfc-shop"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

# 4. Прикріплення прав (AdministratorAccess для навчання)
resource "aws_iam_role_policy_attachment" "tfc_admin" {
  role       = aws_iam_role.tfc.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Вивід ARN створеної ролі
output "role_arn" {
  value = aws_iam_role.tfc.arn
}
