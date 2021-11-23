# Flight Deck

[Terraform] modules for rapidly building production-grade Kubernetes clusters
with built-in support for SRE best practices.

![AWS Architecture](./docs/aws-modules.png)

[Terraform]: https://www.terraform.io/

## Development

You can run Terraform validation and linting on all modules using make:

    make

You will need to install Helm, kubectl, Terraform, terraform-docs, and tflint.

## AWS

Build out and apply root modules using the following modules in order for each
stage of the software development lifecycle:

1. [Network](./aws/network)
1. [Ingress](./aws/ingress)
1. [Cluster](./aws/cluster)
1. [Platform](./aws/workload-platform)
