module "dns_service_account_role" {
  source = "../dns-service-account-role"

  aws_namespace    = var.aws_namespace
  aws_tags         = var.aws_tags
  k8s_namespace    = var.k8s_namespace
  oidc_issuer      = data.aws_ssm_parameter.oidc_issuer.value
  route53_zone_ids = values(data.aws_route53_zone.managed).*.id
}

module "cluster_autoscaler_service_account_role" {
  source = "../cluster-autoscaler-service-account-role"

  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  k8s_namespace = var.k8s_namespace
  oidc_issuer   = data.aws_ssm_parameter.oidc_issuer.value
}

data "aws_route53_zone" "managed" {
  for_each = toset(var.domain_filters)

  name = each.value
}

data "aws_ssm_parameter" "oidc_issuer" {
  name = join("/", concat([""], var.aws_namespace, ["clusters", var.cluster_name, "oidc_issuer"]))
}

data "aws_region" "current" {}
