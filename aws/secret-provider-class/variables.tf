variable "kubernetes_secret_name" {
  description = "Name of the Kubernetes secret to which environment variables will be written; defaults to name"
  type        = string
  default     = null
}

variable "kubernetes_secret_type" {
  description = "Type of Kubernetes secret to create; defaults to opaque"
  type        = string
  default     = "opaque"
}

variable "name" {
  description = "Name of the SecretProviderClass resource"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to which resources will be written"
  type        = string
}

variable "secrets_manager_secrets" {
  description = "Secrets to copy from AWS Secrets Manager"
  type = list(
    object({
      name                  = string,
      environment_variables = list(string),
      jmes_paths = optional(
        list(
          object({
            object_alias = string
            path         = string
          })
        ),
        []
      )
    })
  )
}
