# Flightdeck for AWS

Flightdeck for AWS consists of Terraform modules to provision AWS resources and
configuration for clusters as well as Helm charts and configuration to install
necessary resources into provisioned clusters.

![AWS Architecture](../docs/aws-modules.png)

- [Prerequisites](#prerequisites)
- [Deployment](#deployment)

## Prerequisites

Before installing, you will need:
<!-- Would it be appropriate to recommend resources such as https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tutorials_basic.html so that is clear to the implementer how to meet prerequisites for this repo?  On the flip side, if another group in a large enterprise governs and regulates AWS organizations and accounts, are there considerations for this group, and/or the implementer of this repo to consider beyond these items?  For example, if the target platform already utilizes Terraform Cloud, what might they need to know?  -->
- An AWS account or organization. An organization is recommend to facilitate
  multi-account setup and single sign-on.
- AWS credentials with administrative access to each account.
<!-- Why is this in Cloudformation? If because the Terraform state isn't implemented, Terraform can still be used as a single user in the same way Cloudformation can be -- however if there is a reason beyond priority, it may be useful to specify. -->
- A Terraform state backend in each account. If you don't have state backends
  yet, You can use our [Cloudformation template][cloudformation-state-backend]
  to provision them.

[cloudformation-state-backend]: https://github.com/thoughtbot/cloudformation-terraform-state-backend

## Deployment
<!-- What are the major modules?  What is the order? -->
You can deploy Flightdeck in your AWS organization by applying the major modules
in order.
<!-- If looking from the AWS Organization (or multiple account) level view, what options would the implementer have for implementing multiple clusters with Flightdeck?  How might that work be grouped and controlled with separation of responsibilities? --> 
We recommend separate clusters for pre-production and production. Each cluster
will need a network, ingress stack, cluster, and the Flightdeck platform. We
also recommend isolating the stack for each stage into its own AWS account.

### Network

Flightdeck requires a VPC with public and private subnets. The VPC and subnets
must be tagged following the conventions of the Kubernetes AWS cloud provider.

You can use the same VPC for multiple clusters by using more than one cluster
tag. We recommend using separate VPCs for production and pre-production.

You can create a VPC and all required resources following the required
conventions and our recommended best practices using the [network module]. If
you have an existing VPC you'd like to use, make sure your VPC and its subnets
have the appropriate tags.

[network module]: ./network/README.md

### Ingress

Flightdeck uses application load balancers to route public traffic to the
cluster. You can reuse the same load balancer for multiple clusters, but each
cluster will require its own target group. You can provision a load balancer and
target groups using the [ingress module].

[ingress module]: ./ingress/README.md

### Cluster

Flightdeck deploys on top of AWS EKS. We recommend using separate EKS clusters
for production and pre-production. You can provision the required AWS resources
including an EKS cluster using the [cluster module].

[cluster module]: ./cluster/README.md

### Platform
<!-- Are the charts only for SRE audience specifically?  Many enterprises fit SRE into roles / operation hierarchy which doesn't match the Google definition as specified by the "Building Secure & Reliable Systems" book -- meaning SRE role may be confined to monitoring and building / maintaining monitoring systems, but not responsible for the setup or infrastructure maintenance beyond a cluster, or a SRE may not be responsible for DevSecOps. -->
Flightdeck contains pre-configured Helm charts for SRE. You can deploy the
platform in your clusters using the [platform module].

[platform module]: ./platform/README.md

### Service Account Roles
<!-- Is there a means to test if IAM roles are appropriate (especially tests for overly permissive roles)? What if IAM roles are managed by another group, is the module definition enough for the implementer of this repo to give requirements to that other group? -->
In order for pods running in your cluster to access AWS resources, you will need
to create IAM roles in your AWS accounts and service accounts in your cluster.
You can use the included [service account role module] to create roles that work
with clusters created using Flightdeck.

[service account role module]: ./service-account-role/README.md
