<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.1.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.ingress_config](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_email"></a> [certificate\_email](#input\_certificate\_email) | Email to be notified of certificate expiration and renewal | `string` | n/a | yes |
| <a name="input_certificate_solvers"></a> [certificate\_solvers](#input\_certificate\_solvers) | YAML spec for solving ACME challenges | `string` | n/a | yes |
| <a name="input_domain_names"></a> [domain\_names](#input\_domain\_names) | Domains which are allowed in this cluster | `list(string)` | `[]` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which secrets should be created | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the Helm release | `string` | `"ingress-config"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
