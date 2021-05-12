resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster.name
  instance_types  = var.instance_types
  node_group_name = join("-", concat(var.namespace, [var.name]))
  node_role_arn   = var.role.arn
  subnet_ids      = values(var.subnets).*.id
  tags            = var.tags

  scaling_config {
    desired_size = var.min_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
