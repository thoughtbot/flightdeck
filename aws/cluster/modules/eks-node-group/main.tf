resource "aws_launch_template" "this" {
  name = "flightdeck-eks-launch-template"
  metadata_options {
    http_endpoint = "disabled"
  }
}

resource "aws_eks_node_group" "this" {
  for_each = local.subnets

  capacity_type   = var.capacity_type
  cluster_name    = var.cluster.name
  instance_types  = var.instance_types
  node_group_name = join("-", concat(var.namespace, [var.name, each.key]))
  node_role_arn   = var.role.arn
  subnet_ids      = [each.value.id]

  launch_template {
    id = aws_launch_template.this.id
  }

  scaling_config {
    desired_size = local.min_size_per_node_group
    max_size     = local.max_size_per_node_group
    min_size     = local.min_size_per_node_group
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  labels = merge(var.labels, {
    role = var.label_node_role
  })

  tags = merge(var.tags, {
    AvailabilityZone = each.key
  })

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

locals {
  min_size_per_node_group = ceil(var.min_size / 2)
  max_size_per_node_group = ceil(var.max_size / 2)

  subnets = zipmap(
    var.subnets[*].availability_zone,
    var.subnets
  )
}
