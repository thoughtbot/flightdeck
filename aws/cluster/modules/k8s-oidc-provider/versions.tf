terraform {
  required_version = ">= 0.14.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    tls = {
      version = "~> 3.1"
    }
  }
}
