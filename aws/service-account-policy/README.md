# Service Account Policy

This module creates an [IAM policy] which can be attached to the IAM roles for
your service accounts, granting pods access to the AWS resources specified in
the policy.

Example:

```
module "policy" {
  source = "github.com/thoughtbot/flightdeck//aws/service-account-policy"

  name       = "myservice-production"
  role_names = module.role.name

  policy_documents = [
    # If you have modules which produce JSON policies, you can attach them here
    module.database.policy_json,
    module.ses_sender.policy_json,

    # If you have your own custom policies, you can attach those as well
    data.aws_iam_policy_document.my_custom_policy.json
  ]
}
```

You can combine this module with the [service account role module] to grant
access to AWS services for your pods.

[iam policy]: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
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
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name for the IAM policy | `string` | n/a | yes |
| <a name="input_policy_documents"></a> [policy\_documents](#input\_policy\_documents) | JSON policies to add to the generated policy | `list(string)` | n/a | yes |
| <a name="input_role_names"></a> [role\_names](#input\_role\_names) | Roles to which this policy will be attached | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to created resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the created IAM policy |
| <a name="output_json"></a> [json](#output\_json) | Combined JSON policy |
<!-- END_TF_DOCS -->