resource "aws_eks_node_group" "this" {
  for_each = local.subnets

  capacity_type   = var.capacity_type
  cluster_name    = var.cluster.name
  instance_types  = var.instance_types
  node_group_name = join("-", concat(var.namespace, [var.name, each.key]))
  node_role_arn   = var.role.arn
  subnet_ids      = [each.value.id]

  dynamic "launch_template" {
    for_each = var.metadata_options != {} ? [aws_launch_template.this[0]] : []

    content {
      id      = launch_template.value.id
      version = launch_template.value.latest_version
    }
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

# resource "aws_launch_template" "this" {
#   count = var.user_data != null ? 1 : 0

#   user_data = base64encode(var.user_data)
# }

resource "aws_launch_template" "this" {
  count = var.metadata_options != {} ? 1 : 0

  metadata_options {
    http_endpoint               = lookup(var.metadata_options, "http_endpoint", "enabled")
    http_tokens                 = lookup(var.metadata_options, "http_tokens", "optional")
    http_put_response_hop_limit = lookup(var.metadata_options, "htthttp_put_response_hop_limit", "1")
    http_protocol_ipv6          = lookup(var.metadata_options, "http_protocol_ipv6", "disabled")
    instance_metadata_tags      = lookup(var.metadata_options, "instance_metadata_tags", "disabled")
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
