# Flightdeck

[Terraform] modules for rapidly building production-grade Kubernetes clusters
with built-in support for SRE best practices.

![AWS Architecture](./docs/aws-modules.png)

[Terraform]: https://www.terraform.io/

## Deployment

- [AWS](./aws/README.md)
- [Other](./platform/README.md)

## Development

You can run Terraform validation and linting on all modules using make:

    make

You will need to install Helm, kubectl, Terraform, terraform-docs, and tflint.

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
