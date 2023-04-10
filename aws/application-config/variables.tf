variable "create_namespace" {
  description = "Set to false to disable creation of the Kubernetes namespace"
  type        = bool
  default     = true
}

variable "deploy_cluster_roles" {
  description = "Names of cluster roles for this serviceaccount (default: admin)"
  type        = list(string)
  default     = ["admin"]
}

variable "deploy_group" {
  description = "Name of the Kubernetes group allowed to deploy (default: NAMESPACE-deploy)"
  type        = string
  default     = null
}

variable "deploy_service_account" {
  description = "Name of the Kubernetes service account (default: deploy)"
  type        = string
  default     = "deploy"
}

variable "developer_group" {
  description = "Name of the Kubernetes group used by developers (default: NAMESPACE-developer)"
  type        = string
  default     = null
}

variable "developer_service_account" {
  description = "Name of the Kubernetes service account (default: developer)"
  type        = string
  default     = "developer"
}

variable "enable_exec" {
  description = "Set to true to allow running exec on pods"
  type        = bool
  default     = false
}

variable "namespace" {
  description = "Kubernetes namespace to which this tenant deploys"
  type        = string
}

variable "pod_iam_role" {
  description = "ARN of the role which application pods should assume"
  type        = string
}

variable "pod_service_account" {
  description = "Name of the service account for pods"
  type        = string
}

variable "secret_name" {
  description = "Name of the Kubernetes secret to which environment variables will be written; defaults to secret provider class name"
  type        = string
  default     = null
}

variable "secret_type" {
  description = "Type of Kubernetes secret to create; defaults to opaque"
  type        = string
  default     = "opaque"
}

variable "secret_provider_class" {
  description = "Name of the SecretProviderClass resource (defaults to secretsmanager)"
  type        = string
  default     = "secretsmanager"
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
