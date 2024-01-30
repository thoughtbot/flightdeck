# Specify the required Terraform version. 
terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Add the AWS provider
provider "aws" {
  region = "ADDME" 
	profile = "ADDME"
}


resource "aws_ecr_repository" "flightdeck_getting-started_ecr_repo" {
  name                 = "flightdeck-getting-started"  # Replace with your repository name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
