variable "admin_roles" {
  type        = list(string)
  description = "Additional IAM roles which have admin cluster privileges"
}

variable "aws_ebs_csi_driver_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "aws_ebs_csi_driver_version" {
  type        = string
  description = "Version of the ebs csi driver to install"
  default     = null
}

variable "aws_load_balancer_controller_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "aws_load_balancer_controller_version" {
  type        = string
  description = "Version of aws-load-balancer-controller to install"
  default     = null
}

variable "aws_namespace" {
  type        = list(string)
  default     = []
  description = "Prefix to be applied to created AWS resources"
}

variable "aws_tags" {
  type        = map(string)
  description = "Tags to be applied to created AWS resources"
  default     = {}
}

variable "cert_manager_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "certificate_issuer" {
  type        = string
  description = "YAML spec for certificate issuer; defaults to self-signed"
  default     = null
}

variable "cluster_autoscaler_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "custom_groups" {
  type        = map(list(string))
  description = "List of custom RBAC groups to be assigned to an IAM role for custom cluster privileges,"
  default     = {}
}

variable "custom_roles" {
  type        = map(string)
  description = "Additional IAM roles which have custom cluster privileges"
  default     = {}
}

variable "domain_names" {
  type        = list(string)
  default     = []
  description = "Domains which are allowed in this cluster"
}

variable "external_dns_enabled" {
  description = "Set to true to enable External DNS"
  type        = bool
  default     = false
}

variable "external_dns_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "federated_prometheus_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "flightdeck_prometheus_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "fluent_bit_enable_kubernetes_annotations" {
  description = "Set to true to add Kubernetes annotations to log output"
  type        = bool
  default     = false
}

variable "fluent_bit_enable_kubernetes_labels" {
  description = "Set to true to add Kubernetes labels to log output"
  type        = bool
  default     = false
}

variable "fluent_bit_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "istio_base_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "istiod_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "istio_ingress_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "hosted_zones" {
  type        = list(string)
  description = "Hosted zones this cluster is allowed to update"
  default     = []
}

variable "k8s_namespace" {
  type        = string
  default     = "flightdeck"
  description = "Kubernetes namespace in which resources should be created"
}

variable "logs_retention_in_days" {
  type        = number
  default     = 30
  description = "Number of days for which logs should be retained"
}

variable "logs_prefix" {
  type        = string
  description = "Prefix for CloudWatch log groups"
  default     = "/flightdeck"
}

variable "logs_skip_destroy" {
  type        = bool
  description = "Set to false to destroy the log group with the platform"
  default     = true
}

variable "metrics_server_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "metrics_server_version" {
  type        = string
  description = "Version of the Metrics Server to install"
  default     = null
}

variable "node_roles" {
  type        = list(string)
  description = "Additional node roles which can join the cluster"
  default     = []
}

variable "pagerduty_parameter" {
  type        = string
  description = "SSM parameter containing the Pagerduty routing key"
  default     = null
}

variable "opsgenie_parameter" {
  type        = string
  description = "SSM parameter containing the OpsGenie api key"
  default     = null
}

variable "prometheus_adapter_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "prometheus_operator_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "monitoring_account_id" {
  description = "ID of the account in which monitoring resources are found"
  type        = string
  default     = null
}

variable "prometheus_data_source" {
  description = "Prometheus datasource object with necessary details required to connect to the Prometheus workspace for centralized ingestion"
  type = object({
    # The name of the Prometheus workspace for centralized injestion
    name = string

    # The Prometheus workspace host. 
    # A sample value for AWs managed Prometheus will be `aps-workspaces.us-east-1.amazonaws.com`
    host = string

    # The Prometheus workspace query path. 
    # A sample value for AWs managed Prometheus will be `workspaces/ws-xxxxx-xxx-xxx-xxx-xxxxxxx/api/v1/query`
    query_path = string

    # The region for the Prometheus workspace created for centralized injestion path.
    region = string

    # The ARN of the AWS IAM role enabling this cluster to use the Prometheus workspace for centralized ingestion 
    role_arn = string

    # The write path for the Prometheus workspace. 
    # A sample value for AWs managed Prometheus will be `workspaces/ws-xxxxx-xxx-xxx-xxx-xxxxxxx/api/v1/remote_write`
    write_path = string

    # The url for the Prometheus workspace. 
    # A sample value for AWs managed Prometheus will be `https://aps-workspaces.us-east-1.amazonaws.com/workspaces/ws-xxxxx-xxx-xxx-xxx-xxxxxxx`
    url = string
  })
  default = {
    name       = null
    host       = null
    query_path = null
    region     = null
    role_arn   = null
    write_path = null
    url        = null
  }
}

variable "reloader_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "reloader_version" {
  type        = string
  description = "Version of external-dns to install"
  default     = null
}

variable "secret_store_driver_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "secret_store_driver_version" {
  type        = string
  description = "Version of the secret store driver to install"
  default     = null
}

variable "secret_store_provider_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "vertical_pod_autoscaler_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}
