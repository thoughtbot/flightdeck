# AWS Workload Platform

Deploys the [Flightdeck Workload Platform] to an EKS cluster on AWS.

Appropriate IAM roles for service accounts are configured for CertManager,
Cluster Autoscaler, and ExternalDNS.

[Flightdeck Workload Platform]: ../../common/workload-platform

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
| <a name="module_aws_load_balancer_controller"></a> [aws\_load\_balancer\_controller](#module\_aws\_load\_balancer\_controller) | ../load-balancer-controller |  |
| <a name="module_cloudwatch_logs"></a> [cloudwatch\_logs](#module\_cloudwatch\_logs) | ../cloudwatch-logs |  |
| <a name="module_cluster_autoscaler_service_account_role"></a> [cluster\_autoscaler\_service\_account\_role](#module\_cluster\_autoscaler\_service\_account\_role) | ../cluster-autoscaler-service-account-role |  |
| <a name="module_cluster_name"></a> [cluster\_name](#module\_cluster\_name) | ../cluster-name |  |
| <a name="module_common_platform"></a> [common\_platform](#module\_common\_platform) | ../../common/workload-platform |  |
| <a name="module_dns_service_account_role"></a> [dns\_service\_account\_role](#module\_dns\_service\_account\_role) | ../dns-service-account-role |  |
| <a name="module_network"></a> [network](#module\_network) | ../network-data |  |
| <a name="module_prometheus_service_account_role"></a> [prometheus\_service\_account\_role](#module\_prometheus\_service\_account\_role) | ../prometheus-service-account-role |  |
| <a name="module_secrets_store_provider"></a> [secrets\_store\_provider](#module\_secrets\_store\_provider) | ../secrets-store-provider |  |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_s3_bucket_object.prometheus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket_object) | data source |
| [aws_ssm_parameter.node_role_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.oidc_issuer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.pagerduty_routing_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_roles"></a> [admin\_roles](#input\_admin\_roles) | Additional IAM roles which have admin cluster privileges | `list(string)` | `[]` | no |
| <a name="input_alarm_topic_name"></a> [alarm\_topic\_name](#input\_alarm\_topic\_name) | Name of the SNS topic to which alarms should be sent | `string` | `null` | no |
| <a name="input_aws_load_balancer_controller_values"></a> [aws\_load\_balancer\_controller\_values](#input\_aws\_load\_balancer\_controller\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_aws_load_balancer_controller_version"></a> [aws\_load\_balancer\_controller\_version](#input\_aws\_load\_balancer\_controller\_version) | Version of aws-load-balancer-controller to install | `string` | `null` | no |
| <a name="input_aws_namespace"></a> [aws\_namespace](#input\_aws\_namespace) | Prefix to be applied to created AWS resources | `list(string)` | `[]` | no |
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Tags to be applied to created AWS resources | `map(string)` | `{}` | no |
| <a name="input_cert_manager_values"></a> [cert\_manager\_values](#input\_cert\_manager\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_certificate_issuer"></a> [certificate\_issuer](#input\_certificate\_issuer) | YAML spec for certificate issuer; defaults to self-signed | `string` | `null` | no |
| <a name="input_cluster_autoscaler_values"></a> [cluster\_autoscaler\_values](#input\_cluster\_autoscaler\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_custom_roles"></a> [custom\_roles](#input\_custom\_roles) | Additional IAM roles which have custom cluster privileges | `map(string)` | `{}` | no |
| <a name="input_domain_names"></a> [domain\_names](#input\_domain\_names) | Domains which are allowed in this cluster | `list(string)` | `[]` | no |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Set to true to enable External DNS | `bool` | `false` | no |
| <a name="input_external_dns_values"></a> [external\_dns\_values](#input\_external\_dns\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_federated_prometheus_values"></a> [federated\_prometheus\_values](#input\_federated\_prometheus\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_flightdeck_prometheus_values"></a> [flightdeck\_prometheus\_values](#input\_flightdeck\_prometheus\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_fluent_bit_enable_kubernetes_annotations"></a> [fluent\_bit\_enable\_kubernetes\_annotations](#input\_fluent\_bit\_enable\_kubernetes\_annotations) | Set to true to add Kubernetes annotations to log output | `bool` | `false` | no |
| <a name="input_fluent_bit_enable_kubernetes_labels"></a> [fluent\_bit\_enable\_kubernetes\_labels](#input\_fluent\_bit\_enable\_kubernetes\_labels) | Set to true to add Kubernetes labels to log output | `bool` | `false` | no |
| <a name="input_fluent_bit_values"></a> [fluent\_bit\_values](#input\_fluent\_bit\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_hosted_zones"></a> [hosted\_zones](#input\_hosted\_zones) | Hosted zones this cluster is allowed to update | `list(string)` | `[]` | no |
| <a name="input_istio_discovery_values"></a> [istio\_discovery\_values](#input\_istio\_discovery\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_istio_ingress_values"></a> [istio\_ingress\_values](#input\_istio\_ingress\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which resources should be created | `string` | `"flightdeck"` | no |
| <a name="input_logs_retention_in_days"></a> [logs\_retention\_in\_days](#input\_logs\_retention\_in\_days) | Number of days for which logs should be retained | `number` | `30` | no |
| <a name="input_metrics_server_values"></a> [metrics\_server\_values](#input\_metrics\_server\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_metrics_server_version"></a> [metrics\_server\_version](#input\_metrics\_server\_version) | Version of the Metrics Server to install | `string` | `null` | no |
| <a name="input_monitoring_account_id"></a> [monitoring\_account\_id](#input\_monitoring\_account\_id) | ID of the account in which monitoring resources are found | `string` | `null` | no |
| <a name="input_node_roles"></a> [node\_roles](#input\_node\_roles) | Additional node roles which can join the cluster | `list(string)` | `[]` | no |
| <a name="input_pagerduty_parameter"></a> [pagerduty\_parameter](#input\_pagerduty\_parameter) | SSM parameter containing the Pagerduty routing key | `string` | `null` | no |
| <a name="input_prometheus_adapter_values"></a> [prometheus\_adapter\_values](#input\_prometheus\_adapter\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_prometheus_operator_values"></a> [prometheus\_operator\_values](#input\_prometheus\_operator\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_prometheus_workspace_name"></a> [prometheus\_workspace\_name](#input\_prometheus\_workspace\_name) | Name of the Prometheus workspace for centralized ingestion | `string` | `null` | no |
| <a name="input_reloader_values"></a> [reloader\_values](#input\_reloader\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_reloader_version"></a> [reloader\_version](#input\_reloader\_version) | Version of external-dns to install | `string` | `null` | no |
| <a name="input_secret_store_driver_values"></a> [secret\_store\_driver\_values](#input\_secret\_store\_driver\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_secret_store_driver_version"></a> [secret\_store\_driver\_version](#input\_secret\_store\_driver\_version) | Version of the secret store driver to install | `string` | `null` | no |
| <a name="input_secret_store_provider_values"></a> [secret\_store\_provider\_values](#input\_secret\_store\_provider\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_vertical_pod_autoscaler_values"></a> [vertical\_pod\_autoscaler\_values](#input\_vertical\_pod\_autoscaler\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
