terraform {
  required_version = ">= 1.6.2"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.4"
    }
  }
}