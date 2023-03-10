# AWS Service Account Role

This module creates an [IAM role] which can be assumed by pods in your cluster,
provided access to AWS resources for your application. Without creating a role
for your service account, your pods will be limited to the permissions available
to the nodes running in the cluster.

Roles created by this module IAM role suitable for use in an EKS cluster using
[IRSA]. This module relies on Flightdeck's [SSM parameter conventions] to find
the OIDC provider for the assigned clusters.

To use this role, you must provide:

- A list of cluster names from which this role will be assumable
- A list of service account names in `namespace:serviceaccount` format
- A unique name for the created IAM role

Additionally, you may provide policy documents which will be attached directly
to the role as well as ARNs for managed policies.

Example:

```
module "role" {
  source = "github.com/thoughtbot/flightdeck//aws/service-account-role"

  # Must match the names of clusters created using the [cluster module]
  cluster_names    = ["mycluster-production-v1", "mycluster-production-v2"]
  name             = "myservice-production"
  service_accounts = ["myservice-production:myservice"]

  # If you have modules which produce managed policies, you can attach them here
  managed_policy_arns = [
    module.custom.policy_arn
  ]
}
```

You can combine this module with the [service account policy module] to grant
access to AWS services for your pods.

[iam role]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
[irsa]: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-enable-IAM.html
[cluster module]: ../cluster/README.md
[ssm parameter conventions]: ../../docs/ssm-parameter-conventions.md
[service account policy module]: ../service-account-policy

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_ssm_parameter.oidc_issuer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_names"></a> [cluster\_names](#input\_cluster\_names) | Names of Kubernetes clusters (to look up OIDC issuers) | `list(string)` | `[]` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | List of managed policy ARNs to attach to the role | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the role | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to be applied to created resources | `list(string)` | `[]` | no |
| <a name="input_oidc_issuers"></a> [oidc\_issuers](#input\_oidc\_issuers) | OIDC issuers for Kubernetes clusters | `list(string)` | `[]` | no |
| <a name="input_policy_documents"></a> [policy\_documents](#input\_policy\_documents) | List of policy documents to add to the role's inline policy | `list(string)` | `[]` | no |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | Namespace and name of service accounts allowed to use this role | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to created resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the created role |
| <a name="output_instance"></a> [instance](#output\_instance) | The created role |
| <a name="output_name"></a> [name](#output\_name) | The name of the created role |
<!-- END_TF_DOCS -->