terraform {
  required_version = ">= 0.14.8"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.4"
    }
  }
}
