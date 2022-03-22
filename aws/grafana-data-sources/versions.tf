terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      version = "~> 3.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.13"
    }
  }
}
