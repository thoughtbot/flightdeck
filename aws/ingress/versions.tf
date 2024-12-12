terraform {
  required_version = ">= 0.14.8"
  required_providers {
    aws = {
      configuration_aliases = [aws.cluster, aws.route53]
      source                = "hashicorp/aws"
      version               = "~> 5.0"
    }
  }
}
