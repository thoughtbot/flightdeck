resource "helm_release" "identity_mappings" {
  chart     = "${path.module}/chart"
  name      = "iam-identity-mappings"
  namespace = var.k8s_namespace

  values = [
    yamlencode({
      identityMappings = concat(
        [
          {
            arn      = aws_iam_role.breakglass.arn
            groups   = ["system:masters"]
            name     = "breakglass"
            username = "adminuser:BreakGlass"
          }
        ],
        [
          for node_role in var.node_roles :
          {
            arn      = node_role
            groups   = ["system:bootstrappers", "system:nodes"]
            name     = node_role
            username = "system:node:{{EC2PrivateDNSName}}"
          }
        ],
        [
          for admin_role in var.admin_roles :
          {
            arn      = admin_role
            groups   = ["system:masters"]
            name     = admin_role
            username = "adminuser:{{SessionName}}"
          }
        ],
        [
          for name, arn in var.custom_roles :
          {
            name     = name
            arn      = arn
            groups   = ["system:masters"]
            username = "user:{{SessionName}}"
          }
        ]
      )
    })
  ]
}

data "aws_eks_cluster" "this" {
  name = var.cluster_full_name
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
}
