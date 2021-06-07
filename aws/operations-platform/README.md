# AWS Operations Platform

Deploys the [Flightdeck Operations Platform] to an EKS cluster on AWS.

Appropriate IAM roles for service accounts are configured for ArgoCD,
CertManager, Cluster Autoscaler, and ExternalDNS.

[Flightdeck Operations Platform]: ../../common/operations-platform

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
| <a name="module_argocd_service_account_role"></a> [argocd\_service\_account\_role](#module\_argocd\_service\_account\_role) | ../argocd-service-account-role |  |
| <a name="module_cluster_name"></a> [cluster\_name](#module\_cluster\_name) | ../cluster-name |  |
| <a name="module_common_platform"></a> [common\_platform](#module\_common\_platform) | ../../common/operations-platform |  |
| <a name="module_config_bucket"></a> [config\_bucket](#module\_config\_bucket) | ../s3-bucket |  |
| <a name="module_workload_values"></a> [workload\_values](#module\_workload\_values) | ../workload-values |  |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_object.operations_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.config_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_s3_bucket_object.cluster_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket_object) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_roles"></a> [admin\_roles](#input\_admin\_roles) | Additional IAM roles which have admin cluster privileges | `list(string)` | `[]` | no |
| <a name="input_argocd_github_repositories"></a> [argocd\_github\_repositories](#input\_argocd\_github\_repositories) | GitHub repositories to connect to ArgoCD | `list(string)` | `[]` | no |
| <a name="input_argocd_policy"></a> [argocd\_policy](#input\_argocd\_policy) | Policy grants for ArgoCD RBAC | `string` | `""` | no |
| <a name="input_argocd_values"></a> [argocd\_values](#input\_argocd\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_aws_namespace"></a> [aws\_namespace](#input\_aws\_namespace) | Prefix to be applied to created AWS resources | `list(string)` | `[]` | no |
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Tags to be applied to created AWS resources | `map(string)` | `{}` | no |
| <a name="input_cert_manager_values"></a> [cert\_manager\_values](#input\_cert\_manager\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_certificate_email"></a> [certificate\_email](#input\_certificate\_email) | Email to be notified of certificate expiration and renewal | `string` | n/a | yes |
| <a name="input_cluster_autoscaler_values"></a> [cluster\_autoscaler\_values](#input\_cluster\_autoscaler\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_config_bucket"></a> [config\_bucket](#input\_config\_bucket) | Name of the S3 bucket for storing Flightdeck configuration | `string` | n/a | yes |
| <a name="input_custom_roles"></a> [custom\_roles](#input\_custom\_roles) | Additional IAM roles which have custom cluster privileges | `map(string)` | `{}` | no |
| <a name="input_dex_extra_secrets"></a> [dex\_extra\_secrets](#input\_dex\_extra\_secrets) | Extra values to append to the Dex secret | `map(string)` | `{}` | no |
| <a name="input_dex_values"></a> [dex\_values](#input\_dex\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_domain_filters"></a> [domain\_filters](#input\_domain\_filters) | Domains on which External DNS should update entries | `list(string)` | `[]` | no |
| <a name="input_external_dns_values"></a> [external\_dns\_values](#input\_external\_dns\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_host"></a> [host](#input\_host) | Base hostname for flightdeck UI | `string` | n/a | yes |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which resources should be created | `string` | `"flightdeck"` | no |
| <a name="input_kustomize_versions"></a> [kustomize\_versions](#input\_kustomize\_versions) | Versions of Kustomize to install | `list(string)` | <pre>[<br>  "3.10.0"<br>]</pre> | no |
| <a name="input_node_roles"></a> [node\_roles](#input\_node\_roles) | Additional node roles which can join the cluster | `list(string)` | `[]` | no |
| <a name="input_prometheus_operator_values"></a> [prometheus\_operator\_values](#input\_prometheus\_operator\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_workload_account_ids"></a> [workload\_account\_ids](#input\_workload\_account\_ids) | IDs of AWS accounts in which workloads will run | `list(string)` | `[]` | no |
| <a name="input_workload_cluster_names"></a> [workload\_cluster\_names](#input\_workload\_cluster\_names) | Names of workload clusters to which ArgoCD will deploy | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_argocd_service_account_role_arn"></a> [argocd\_service\_account\_role\_arn](#output\_argocd\_service\_account\_role\_arn) | ARN of the IAM role used by ArgoCD's service account |
<!-- END_TF_DOCS -->
