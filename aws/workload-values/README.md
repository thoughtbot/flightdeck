<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_auth_config_map"></a> [auth\_config\_map](#module\_auth\_config\_map) | ../auth-config-map |  |
| <a name="module_cloudwatch_logs"></a> [cloudwatch\_logs](#module\_cloudwatch\_logs) | ../cloudwatch-logs |  |
| <a name="module_cluster_autoscaler_service_account_role"></a> [cluster\_autoscaler\_service\_account\_role](#module\_cluster\_autoscaler\_service\_account\_role) | ../cluster-autoscaler-service-account-role |  |
| <a name="module_dns_service_account_role"></a> [dns\_service\_account\_role](#module\_dns\_service\_account\_role) | ../dns-service-account-role |  |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_ssm_parameter.node_role_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.oidc_issuer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.pagerduty_routing_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_roles"></a> [admin\_roles](#input\_admin\_roles) | IAM roles which will have admin privileges in this cluster | `list(string)` | n/a | yes |
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Tags to be applied to created AWS resources | `map(string)` | `{}` | no |
| <a name="input_cluster_full_name"></a> [cluster\_full\_name](#input\_cluster\_full\_name) | Full name of the EKS cluster | `string` | n/a | yes |
| <a name="input_custom_roles"></a> [custom\_roles](#input\_custom\_roles) | Additional IAM roles which have custom cluster privileges | `map(string)` | `{}` | no |
| <a name="input_hosted_zones"></a> [hosted\_zones](#input\_hosted\_zones) | Hosted zones this cluster is allowed to update | `list(string)` | `[]` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which resources should be created | `string` | `"flightdeck"` | no |
| <a name="input_logs_retention_in_days"></a> [logs\_retention\_in\_days](#input\_logs\_retention\_in\_days) | Number of days for which logs should be retained | `number` | `30` | no |
| <a name="input_node_roles"></a> [node\_roles](#input\_node\_roles) | Additional node roles which can join the cluster | `list(string)` | `[]` | no |
| <a name="input_pagerduty_parameter"></a> [pagerduty\_parameter](#input\_pagerduty\_parameter) | SSM parameter containing the Pagerduty routing key | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_values"></a> [cert\_manager\_values](#output\_cert\_manager\_values) | AWS-specific values for cert-manager |
| <a name="output_cluster_autoscaler_values"></a> [cluster\_autoscaler\_values](#output\_cluster\_autoscaler\_values) | AWS-specific values for cluster-autoscaler |
| <a name="output_external_dns_values"></a> [external\_dns\_values](#output\_external\_dns\_values) | AWS-specific values for external-dns |
| <a name="output_fluent_bit_values"></a> [fluent\_bit\_values](#output\_fluent\_bit\_values) | AWS-specific values for Fluent Bit |
| <a name="output_istio_ingress_values"></a> [istio\_ingress\_values](#output\_istio\_ingress\_values) | AWS-specific values for Istio Ingress Gateway |
| <a name="output_oidc_issuer"></a> [oidc\_issuer](#output\_oidc\_issuer) | OIDC issuer configured for this cluster |
| <a name="output_pagerduty_routing_key"></a> [pagerduty\_routing\_key](#output\_pagerduty\_routing\_key) | Routing key for delivering alerts to Pagerduty |
| <a name="output_prometheus_operator_values"></a> [prometheus\_operator\_values](#output\_prometheus\_operator\_values) | AWS-specific values for Prometheus Operator |
<!-- END_TF_DOCS -->