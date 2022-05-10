# AWS Network

Provisions an AWS VPC and other components required for an EKS cluster,
including public and private subnets, route tables, routes, and NAT gateways. We
recommend using separate VPCs for production and pre-production.

![Network Diagram](../../docs/aws-vpc.png)

## Example

```terraform
module "network" {
  source = "github.com/thoughtbot/flightdeck//aws/network?ref=v0.4.0"

  # Unique name for the Name tag displayed in AWS Management Console.
  name                   = "example-production"

  # Names of Kubernetes clusters allowed to use this network.
  # Clusters should be listed here before they're created.
  cluster_names          = ["example-production-v1"]

  # Primary CIDR block for the VPC.
  # We recommend this doesn't overlap with any other VPCs in your organization.
  vpc_cidr_block         = "10.200.0.0/16"

  # Availability zones in which NAT gateways should be created.
  # You can list a single zone if you only want one NAT gateway.
  nat_availability_zones = ["us-east-1a", "us-east-1b"]

  # Availability zones for which private subnets should be created.
  # At least two subnets are recommended. Must be a subset of the VPC CIDR.
  private_subnet_cidr_blocks = {
    "us-east-1a" = "10.200.64.0/18"
    "us-east-1b" = "10.200.128.0/18"
  }

  # Availability zones for which public subnets should be created.
  # At least two subnets are recommended. Must be a subset of the VPC CIDR.
  public_subnet_cidr_blocks = {
    "us-east-1a" = "10.200.0.0/20"
    "us-east-1b" = "10.200.16.0/20"
  }

  # Any extra tags you want to apply to all created resources.
  tags = {
    Module = "vpc/production"
  }
}
```
