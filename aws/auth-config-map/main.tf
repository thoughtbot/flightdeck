resource "helm_release" "aws_auth" {
  chart     = "${path.module}/chart"
  name      = "aws-auth"
  namespace = "kube-system"
  values    = [yamlencode({ mapRoles = local.map_roles })]
}

locals {
  map_roles = concat(
    [
      for role in var.admin_roles :
      {
        groups   = ["system:masters"]
        rolearn  = role
        username = "adminuser:{{SessionName}}"
      }
    ],
    [
      for group in keys(var.custom_roles) :
      {
        groups   = [group]
        rolearn  = var.custom_roles[group]
        username = "user:{{SessionName}}"
      }
    ],
    [
      for role in var.node_roles :
      {
        username = "system:node:{{EC2PrivateDNSName}}"
        rolearn  = role
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ]
  )
}
