module "cluster_name" {
  source = "../cluster-name"

  name      = var.name
  namespace = var.namespace
}

module "network" {
  source = "../network-data"

  private_tags = module.cluster_name.private_tags
  public_tags  = module.cluster_name.public_tags
  tags         = module.cluster_name.shared_tags
}

module "eks_cluster" {
  source = "./modules/eks-cluster"

  auth_mode                                  = var.auth_mode
  bootstrap_cluster_creator_admin_permission = var.bootstrap_cluster_creator_admin_permission
  enabled_cluster_log_types                  = var.enabled_cluster_log_types
  endpoint_private_access                    = var.endpoint_private_access
  endpoint_public_access                     = var.endpoint_public_access
  k8s_version                                = var.k8s_version
  log_retention_in_days                      = var.log_retention_in_days
  name                                       = module.cluster_name.full
  private_subnet_ids                         = module.network.private_subnet_ids
  public_subnet_ids                          = module.network.public_subnet_ids
  tags                                       = var.tags
  vpc                                        = module.network.vpc

  depends_on = [module.node_role]
}

module "node_role" {
  source = "./modules/eks-node-role"

  name = module.cluster_name.full
  tags = var.tags
}

module "node_groups" {
  for_each = var.node_groups
  source   = "./modules/eks-node-group"

  capacity_type   = each.value.capacity_type
  cluster         = module.eks_cluster.instance
  instance_types  = each.value.instance_types
  enforce_imdsv2  = each.value.enforce_imdsv2
  labels          = var.labels
  max_size        = each.value.max_size
  max_unavailable = each.value.max_unavailable
  min_size        = each.value.min_size
  name            = each.key
  namespace       = [module.cluster_name.full]
  role            = module.node_role.instance
  subnets         = values(data.aws_subnet.private)
  tags            = var.tags

  depends_on = [module.node_role]
}

module "aws_k8s_oidc_provider" {
  source = "./modules/k8s-oidc-provider"

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

data "aws_subnet" "private" {
  for_each = toset(module.network.private_subnet_ids)
  id       = each.value
}
