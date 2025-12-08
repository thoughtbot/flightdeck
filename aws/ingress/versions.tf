terraform {
  required_version = ">= 1.6.2"
  required_providers {
    aws = {
      configuration_aliases = [aws.cluster, aws.route53, aws.alb]
      source                = "hashicorp/aws"
      version               = "~> 6.0"
    }
  }
}
