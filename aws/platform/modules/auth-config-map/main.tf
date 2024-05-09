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
  name = var.cluster_full_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

data "aws_caller_identity" "this" {
}

resource "aws_iam_role" "breakglass" {
  assume_role_policy = data.aws_iam_policy_document.breakglass_trust.json
  name               = "${var.cluster_full_name}-breakglass"
  tags               = { Enabled = "False" }
}

data "aws_iam_policy_document" "breakglass_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }

    condition {
      test     = "StringEquals"
      values   = ["True"]
      variable = "aws:ResourceTag/Enabled"
    }
  }
}

resource "aws_iam_role_policy" "breakglass" {
  name   = "breakglass"
  policy = data.aws_iam_policy_document.breakglass.json
  role   = aws_iam_role.breakglass.id
}

data "aws_iam_policy_document" "breakglass" {
  statement {
    actions   = ["eks:AccessKubernetesApi"]
    resources = [data.aws_eks_cluster.this.arn]

    condition {
      test     = "StringEquals"
      values   = ["True"]
      variable = "aws:PrincipalTag/Enabled"
    }
  }
}

locals {
  account_id = data.aws_caller_identity.this.account_id
  map_roles  = "    ${indent(4, yamlencode(local.mappings))}"

  mappings = concat(
    [
      {
        groups   = ["system:masters"]
        rolearn  = aws_iam_role.breakglass.arn
        username = "adminuser:BreakGlass"
      }
    ],
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
      for role, groups in var.custom_groups :
      {
        groups   = groups
        rolearn  = role
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

