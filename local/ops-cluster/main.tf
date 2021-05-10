terraform {
  backend "local" {}
}

provider "helm" {
  kubernetes {
    config_path = "../../tmp/kubeconfig"
  }
}

provider "kubernetes" {
  config_path = "../../tmp/kubeconfig"
}

module "ops_cluster" {
  source = "../../terraform/common/ops-cluster"

  dex_values = [file("${path.module}/dex-values.yaml")]
  host       = var.host
  ui_values  = [file("${path.module}/ui-values.yaml")]
}

variable "host" {
  type = string
}

output "flightdeck_url" {
  description = "URL at which Flightdeck is available"
  value       = module.ops_cluster.url
}
