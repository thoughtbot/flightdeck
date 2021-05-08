terraform {
  backend "local" {}
}

provider "kubernetes" {
  config_path = "../../tmp/kubeconfig"
}

module "ops_cluster" {
  source = "../../terraform/common/ops-cluster"

  host = var.host
}

variable "host" {
  type = string
}
