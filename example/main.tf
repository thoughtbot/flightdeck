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
  region = "us-west-2" 
}

# Flightdeck Module for EKS Cluster.  You'll reference the Flightdeck repository and specify the required parameters.
module "eks_cluster" {
  source = "github.com/thoughtbot/flightdeck//aws/eks?ref=latest"


	# Replace "flightdeck-example-eks-cluster" with your desired cluster name and fill in other configurations as needed.
  cluster_name = "flightdeck-example-eks-cluster"

  # Define other necessary configurations for your cluster
}

# Flightdeck Platform Module.  Add the Flightdeck platform module to configure the Kubernetes setup on the EKS cluster.
module "flightdeck_platform" {
  source = "github.com/thoughtbot/flightdeck//aws/platform?ref=latest"

  cluster_name = module.eks_cluster.cluster_name
	admin_roles  = ["arn:aws:iam::123456789012:role/AdminRole"]

  # Specify other required configurations
  # Define additional configurations for the platform
}
