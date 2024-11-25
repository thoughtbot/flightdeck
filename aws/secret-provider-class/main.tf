locals {
  environment_variables = flatten(var.secrets_manager_secrets[*].environment_variables)

  objects = yamlencode([
    for secret in var.secrets_manager_secrets :
    {
      objectName = secret.name
      objectType = "secretsmanager"

      jmesPath = coalescelist(
        [
          for jmes_path in secret.jmes_paths :
          {
            path = jmes_path.path,
            objectAlias : jmes_path.object_alias
          }
        ],
        [
          for key in secret.environment_variables :
          {
            path        = key
            objectAlias = key
          }
        ]
      )
    }
  ])
}

resource "kubernetes_manifest" "secretproviderclass" {
  manifest = {
    apiVersion = "secrets-store.csi.x-k8s.io/v1alpha1"
    kind       = "SecretProviderClass"
    metadata = {
      name      = var.name
      namespace = var.namespace
    }
    spec = {
      parameters = {
        objects = local.objects
      }
      provider = "aws"
      secretObjects = [
        {
          secretName = coalesce(var.kubernetes_secret_name, var.name)
          type       = var.kubernetes_secret_type
          data = [
            for key in local.environment_variables :
            {
              key        = key
              objectName = key
            }
          ]
        },
      ]
    }
  }
}
