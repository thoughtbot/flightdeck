# AWS Cluster

Creates a Kubernetes cluster capable of running the Flightdeck platform using
Terraform and EKS. A different node group is created for each availability zone
so that node counts will grow equally in each availability zone and so that
nodes will be able to reliably attach EBS volumes. An [OIDC
provider](./modules/k8s-oidc-provider) is configured to enable [IRSA].

![Cluster diagram](../../docs/eks-cluster.png)

The module will look up VPC subnets for the cluster using the cluster name. The
VPC and subnets must be tagged following the conventions of the Kubernetes AWS
cloud provider:

| Tag                             | Value  | Add to              |
| ------------------------------- | ------ | ------------------- |
| kubernetes.io/role/internal-elb | 1      | Private subnets     |
| kubernetes.io/role/elb          | 1      | Public subnets      |
| kubernetes.io/cluster/NAME      | shared | VPC and all subnets |

You can quickly create a compatible network using the [network module]. If
you're bringing your own VPC, you must tag resources as documented above before
creating your cluster.

[network module]: ../network/README.md
[irsa]: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-enable-IAM.html

## Example

```terraform
module "cluster" {
  source = "github.com/thoughtbot/flightdeck//aws/cluster?ref=v0.4.0"

  # Unique name for this EKS cluster.
  name = "example-production-v1"

  # Version of Kubernetes for this cluster. Must be supported by EKS.
  k8s_version = "1.21"

  node_groups = {
    # You need at least one node group definition.
    default = {
      instance_types = ["t3.large"]
      max_size       = 30
      min_size       = 2
    }

    # You can include extra node groups if you want more than one type of node.
    m5_2xlarge = {
      instance_types = ["m5.2xlarge"]
      max_size       = 30
      min_size       = 2
    }
  }

  # Any tags you want to apply to all created resources.
  tags = { Module = "cluster/production-v1" }
}
```
