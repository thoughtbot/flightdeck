# Flightdeck for AWS

Flightdeck for AWS consists of Terraform modules to provision AWS resources and
configuration for clusters as well as Helm charts and configuration to install
necessary resources into provisioned clusters.

![AWS Architecture](../docs/aws-modules.png)

- [Prerequisites](#prerequisites)
- [Deployment](#deployment)

## Prerequisites

Before installing, you will need:

- An AWS account or organization. An organization is recommend to facilitate
  multi-account setup and single sign-on.
- AWS credentials with administrative access to each account.
- A Terraform state backend in each account. If you don't have state backends
  yet, You can use our [Cloudformation template][cloudformation-state-backend]
  to provision them.

[cloudformation-state-backend]: https://github.com/thoughtbot/cloudformation-terraform-state-backend

## Deployment

You can deploy Flightdeck in your AWS organization by applying the major modules
in order.

We recommend separate clusters for pre-production and production. Each cluster
will need a network, ingress stack, cluster, and the Flightdeck platform. We
also recommend isolating the stack for each stage into its own AWS account.

### Network

Flightdeck requires a VPC with public and private subnets. The VPC and subnets
must be tagged following the conventions of the Kubernetes AWS cloud provider:

| Tag                             | Value  |
| ---                             | -----  |
| kubernetes.io/role/internal-elb | 1      |
| kubernetes.io/role/elb          | 1      |
| kubernetes.io/cluster/NAME      | shared |

You can use the same VPC for multiple clusters by using more than one cluster
tag. We recommend using separate VPCs for production and pre-production.

You can create a VPC and all required resources following the required
conventions and our recommended best practices using the [network module]. If
you have an existing VPC you'd like to use, make sure your VPC and its subnets
have the appropriate tags.

[network module]: ./network/README.md

### Ingress

Flightdeck uses application load balancers to route public traffic to the
cluster.  You can reuse the same load balancer for multiple clusters, but each
cluster will require its own target group. You can provision a load balancer and
target groups using the [ingress module].

[ingress module]: ./ingress/README.md

### Cluster

Flightdeck deploys on top of AWS EKS. We recommend using separate EKS clusters
for production and pre-production. You can provision the required AWS resources
including an EKS cluster using the [cluster module].

[cluster module]: ./cluster/README.md

### Platform

Flightdeck contains pre-configured Helm charts for SRE. You can deploy the
platform in your clusters using the [platform module].

[platform module]: ./platform/README.md

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
