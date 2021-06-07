module "auth_config_map" {
  source = "../auth-config-map"

  admin_roles       = var.admin_roles
  cluster_full_name = var.cluster_full_name
  custom_roles      = var.custom_roles
  node_roles        = concat(local.node_roles, var.node_roles)
}

module "dns_service_account_role" {
  source = "../dns-service-account-role"

  aws_namespace    = [var.cluster_full_name]
  aws_tags         = var.aws_tags
  k8s_namespace    = var.k8s_namespace
  oidc_issuer      = data.aws_ssm_parameter.oidc_issuer.value
  route53_zone_ids = values(data.aws_route53_zone.managed).*.id
}

module "cluster_autoscaler_service_account_role" {
  source = "../cluster-autoscaler-service-account-role"

  aws_namespace = [var.cluster_full_name]
  aws_tags      = var.aws_tags
  k8s_namespace = var.k8s_namespace
  oidc_issuer   = data.aws_ssm_parameter.oidc_issuer.value
}

data "aws_route53_zone" "managed" {
  for_each = toset(var.domain_filters)

  name = each.value
}

data "aws_ssm_parameter" "oidc_issuer" {
  name = join("/", concat(
    [""],
    ["flightdeck", var.cluster_full_name, "oidc_issuer"]
  ))
}

data "aws_region" "current" {}

data "aws_ssm_parameter" "node_role_arn" {
  name = join("/", concat(
    [""],
    ["flightdeck", var.cluster_full_name, "node_role_arn"]
  ))
}

locals {
  node_roles = [data.aws_ssm_parameter.node_role_arn.value]
}
