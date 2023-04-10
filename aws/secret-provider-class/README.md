# AWS Secret Provider Class

This module creates a [Secret Provider Class] which can be used to inject
secrets from [AWS Secrets Manager] into an application.

Example:

``` hcl
module "secret_provider_class" {
  source = "github.com/thoughtbot/flightdeck//aws/secret-provider-class"

  # Name of the secret provider class; must match name in your manifests
  name = "example"

  secrets_manager_secrets = [
    # Map an environment variable from a SecretsManager secret
    {
      name                  = "rds-postgres-example"
      environment_variables = ["DATABASE_URL"]
    },
    # Map multiple environment variables
    {
      name                  = "smtp"
      environment_variables = ["SMTP_PASSWORD", "SMTP_USERNAME"]
    },
    # Use a custom JMES path to create an alias
    {
      name                  = "rds-postgres-replica"
      environment_variables = ["DATABASE_REPLICA_URL"]
      jmes_paths = [
        {
          object_alias = "DATABASE_REPLICA_URL"
          path         = "DATABASE_URL"
        },
      ]
    },
  ]
}
```

Once the secret provider class has been created by this module, you can mount it
in your deployment or other pods:

``` yaml
volumes:
- name: secretsmanager
  csi:
    driver: secrets-store.csi.k8s.io
    readOnly: true
    volumeAttributes:
      secretProviderClass: example

containers:
- name: main

  # Mount the secret as environment variables
  envFrom:
  - secretRef:
      name: example

  # You must also mount the volume to create the secret
  volumeMounts:
  - name: secretsmanager
    mountPath: /secretsmanager
    readOnly: true
```

[Secret Provider Class]: https://secrets-store-csi-driver.sigs.k8s.io/concepts.html#secretproviderclass
[AWS Secrets Manager]: https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.6 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.secretproviderclass](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kubernetes_secret_name"></a> [kubernetes\_secret\_name](#input\_kubernetes\_secret\_name) | Name of the Kubernetes secret to which environment variables will be written; defaults to name | `string` | `null` | no |
| <a name="input_kubernetes_secret_type"></a> [kubernetes\_secret\_type](#input\_kubernetes\_secret\_type) | Type of Kubernetes secret to create; defaults to opaque | `string` | `"opaque"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the SecretProviderClass resource | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to which resources will be written | `string` | n/a | yes |
| <a name="input_secrets_manager_secrets"></a> [secrets\_manager\_secrets](#input\_secrets\_manager\_secrets) | Secrets to copy from AWS Secrets Manager | <pre>list(<br>    object({<br>      name                  = string,<br>      environment_variables = list(string),<br>      jmes_paths = optional(<br>        list(<br>          object({<br>            object_alias = string<br>            path         = string<br>          })<br>        ),<br>        null<br>      )<br>    })<br>  )</pre> | n/a | yes |
<!-- END_TF_DOCS -->
