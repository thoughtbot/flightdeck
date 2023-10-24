Terraform module to setup the management account and promote a member account to become a delegated backup administrator.

It will also add an organization policy in the management account to manage the permitted actions by the delegated backup adminstrator in the organization.

## Example

```terraform
 module "backup-organization-policy" {
   source    = "github.com/thoughtbot/flightdeck//aws/backup/backup-organization-policy?ref=VERSION"

   providers = { aws = aws.management }

   delegate_account_id = var.delegate_account_id
 }
```

### Granting permissions to the management account.

The `backup-organization-policy` module will require permissions in the management account to the delegated backup account a delegated backup administrator. You may create an IAM role using the provided IAM policy below.

```terraform
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "RegisterDelegatedAdmin",
                "Action": [
                    "organizations:RegisterDelegatedAdministrator"
                ],
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Sid": "UpdateAwsBackupGlobalSetting",
                "Action": [
                    "backup:UpdateGlobalSettings"
                ],
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Sid": "ManageAwsOrganizationResourcePolicy",
                "Action": [
                    "organizations:PutResourcePolicy",
                    "organizations:DeleteResourcePolicy"
                ],
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Sid": "DescribeAwsOrganizationResources",
                "Action": [
                    "organizations:Describe*",
                    "organizations:List*"
                ],
                "Effect": "Allow",
                "Resource": "*"
            }
        ]
}
```

You may then use the created IAM role as a provider for the `backup-organization-policy`  terraform module 

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
| [aws_backup_global_settings.cross_account_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_global_settings) | resource |
| [aws_organizations_delegated_administrator.management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_organizations_resource_policy.allow_delegated_backup_administrator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_resource_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.organization_backup_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delegate_account_id"></a> [delegate\_account\_id](#input\_delegate\_account\_id) | AWS account id for the delagate backup account | `string` | n/a | yes |
<!-- END_TF_DOCS -->