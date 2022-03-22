terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.4"
    }
  }
}
