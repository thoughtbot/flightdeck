module "cluster_autoscaler_service_account_role" {
  source = "../cluster-autoscaler-service-account-role"

  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  k8s_namespace = var.k8s_namespace
  oidc_issuer   = var.oidc_issuer
}

module "dns_service_account_role" {
  source = "../dns-service-account-role"

  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  k8s_namespace = var.k8s_namespace
  oidc_issuer   = var.oidc_issuer
}
