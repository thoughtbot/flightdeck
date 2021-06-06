module "cluster_name" {
  source = "../cluster-name"

  name      = var.name
  namespace = var.namespace
}

module "network" {
  source = "../network-data"

  network_tags = module.cluster_name.shared_tags
  private_tags = module.cluster_name.private_tags
  public_tags  = module.cluster_name.public_tags
}

module "eks_cluster" {
  source = "../eks-cluster"

  enabled_cluster_log_types = var.enabled_cluster_log_types
  k8s_version               = var.k8s_version
  log_retention_in_days     = var.log_retention_in_days
  name                      = module.cluster_name.full
  private_subnets           = module.network.private_subnets
  public_subnets            = module.network.public_subnets
  tags                      = var.tags
  vpc                       = module.network.vpc
}

module "node_role" {
  source = "../eks-node-role"

  name = module.cluster_name.full
  tags = var.tags
}

module "node_groups" {
  for_each = var.node_groups
  source   = "../eks-node-group"

  cluster        = module.eks_cluster.instance
  instance_types = each.value.instance_types
  max_size       = each.value.max_size
  min_size       = each.value.min_size
  name           = each.key
  namespace      = [module.cluster_name.full]
  role           = module.node_role.instance
  subnets        = module.network.private_subnets
  tags           = var.tags

  depends_on = [module.node_role]
}

module "aws_k8s_oidc_provider" {
  source = "../k8s-oidc-provider"

  cluster = module.eks_cluster.instance
}

resource "aws_ssm_parameter" "oidc_issuer" {
  name  = join("/", concat(["", "flightdeck", module.cluster_name.full, "oidc_issuer"]))
  type  = "SecureString"
  value = module.aws_k8s_oidc_provider.issuer
}

resource "aws_ssm_parameter" "node_role_arn" {
  name  = join("/", concat(["", "flightdeck", module.cluster_name.full, "node_role_arn"]))
  type  = "SecureString"
  value = module.node_role.arn
}
