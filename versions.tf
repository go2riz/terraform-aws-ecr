terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # aws_ecr_account_setting was added in newer provider versions; keep a sensible minimum.
      version = ">= 5.81.0"
    }
  }
}
