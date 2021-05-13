resource "null_resource" "aws_auth_patch" {
  triggers = {
    ca_data   = sha256(data.aws_eks_cluster.this.certificate_authority[0].data)
    map_roles = local.map_roles
    server    = sha256(data.aws_eks_cluster.this.endpoint)
  }

  provisioner "local-exec" {
    command     = "./aws-auth-patch.sh"
    working_dir = path.module

    environment = {
      KUBE_CA_DATA = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
      KUBE_SERVER  = data.aws_eks_cluster.this.endpoint
      KUBE_TOKEN   = data.aws_eks_cluster_auth.this.token
      MAP_ROLES    = local.map_roles
    }
  }
}

data "aws_eks_cluster" "this" {
  name = join("-", concat(var.aws_namespace, [var.cluster_name]))
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

locals {
  map_roles = "    ${indent(4, yamlencode(local.mappings))}"

  mappings = concat(
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

