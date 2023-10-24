Terraform module to create a backup vault in the specified account and region.

Vaults are region specific for each account, so a vault must be created for each region in each account that will need to store a backup.

Note: It is recommeneded to use the same vault name across the organization.

## Example

```terraform
 module "workload-account-vault" {
   source    = "github.com/thoughtbot/flightdeck//aws/backup/backup-vault?ref=VERSION"

   providers = { aws = aws.workload_account_ue1 }

   vault_name = local.vault_name
 }

 module "backup-account-vault" {
   source    = "github.com/thoughtbot/flightdeck//aws/backup/backup-vault?ref=VERSION"

   providers = { aws = aws.backup_account_ue1 }

   vault_name = local.vault_name
 }

 locals {
    vault_name = "user-backup-vault"
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
| [aws_backup_vault.account_vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_policy.account_vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_kms_key.primary_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_principals"></a> [admin\_principals](#input\_admin\_principals) | Principals allowed to peform admin actions (default: current account) | `list(string)` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates that all recovery points stored in the vault are deleted so that the vault can be destroyed without error. | `bool` | `false` | no |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | Unique name for the backup vault | `string` | `"aws_backup_vault"` | no |
<!-- END_TF_DOCS -->