# Flight Deck

[Terraform] modules for cloud deployments compatible with [flightctl].

![AWS Architecture](./docs/aws-modules.png)

## Architecture

Flightdeck supports a multi-cluster architecture. You can deploy a single
cluster and run your workloads there, or you can deploy an operations cluster
and several workload clusters. This can be helpful for separating your
production from development workloads.

[Terraform]: https://www.terraform.io/
[flightctl]: https://github.com/thoughtbot/flightctl

## Development

You can get a local Flightdeck cluster by running:

    make local

## AWS

You can create clusters, complete with VPC, node groups, and OIDC setup, using
the [AWS cluster module].

Deploy the [AWS operations platform] to one cluster. If you're building out
multiple clusters, deploy the [AWS workload platform] to the other clusters.

[AWS cluster module]: ./aws/cluster
[AWS operations platform]: ./aws/operations-platform
[AWS workload platform]: ./aws/workload-platform
