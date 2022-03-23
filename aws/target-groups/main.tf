module "network" {
  source = "../network-data"

  tags = merge(local.cluster_tags, var.network_tags)
}

module "cluster_name" {
  for_each = toset(var.cluster_names)
  source   = "../cluster-name"

  name = each.value
}

locals {
  cluster_tags = merge(
    values(module.cluster_name).*.shared_tags...
  )

  target_groups = zipmap(
    var.cluster_names,
    [
      for cluster in var.cluster_names :
      {
        # This is the health check endpoint for istio-ingressgateway
        health_check_path = "/healthz/ready"
        health_check_port = 15021
        name              = cluster
      }
    ]
  )
}
