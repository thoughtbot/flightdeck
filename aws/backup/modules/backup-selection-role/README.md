Terraform module to create a backup selection role. The backup selection role is used by AWS Backup to select resources in the target account that are to be backed up.

## Example

```terraform
 module "backup-selection-role" {
   source    = "github.com/thoughtbot/flightdeck//aws/backup/backup-selection-role?ref=VERSION"

   providers = { aws = aws.workload_account_ue1 }

   backup_selection_role_name = "backup-selection-role"
 }
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.backup_selection_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.backup_selection_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_selection_role_name"></a> [backup\_selection\_role\_name](#input\_backup\_selection\_role\_name) | Unique name for the backup policy | `string` | `"backup-selection-role"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_selection_role_arn"></a> [selection\_role\_arn](#output\_selection\_role\_arn) | Arn for the backup selection role |
| <a name="output_selection_role_name"></a> [selection\_role\_name](#output\_selection\_role\_name) | Backup selection role name |
<!-- END_TF_DOCS -->