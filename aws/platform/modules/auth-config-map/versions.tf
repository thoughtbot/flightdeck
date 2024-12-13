terraform {
  required_version = ">= 0.14.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
}
