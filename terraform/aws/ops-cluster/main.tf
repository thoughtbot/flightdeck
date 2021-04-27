module "ops_cluster" {
  source = "../../common/ops-cluster"

  host          = var.host
  k8s_namespace = var.k8s_namespace
}

module "argocd_service_account_role" {
  source = "../argocd-service-account-role"

  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  k8s_namespace = module.ops_cluster.namespace
  oidc_issuer   = var.oidc_issuer
}

module "dns_service_account_role" {
  source = "../dns-service-account-role"

  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  k8s_namespace = module.ops_cluster.namespace
  oidc_issuer   = var.oidc_issuer
}

module "cluster_common" {
  source = "../cluster-common"

  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  k8s_namespace = module.ops_cluster.namespace
  oidc_issuer   = var.oidc_issuer
}
