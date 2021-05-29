locals {
  argocd_cluster_config = {
    name   = var.cluster_full_name
    server = data.aws_eks_cluster.this.endpoint
    config = {
      awsAuthConfig = {
        clusterName = var.cluster_full_name
        roleARN     = aws_iam_role.argocd.arn
      }
      tlsClientConfig = {
        caData = data.aws_eks_cluster.this.certificate_authority[0].data
      }
    }
  }
}

resource "aws_iam_role" "argocd" {
  assume_role_policy = data.aws_iam_policy_document.argocd_assume_role.json
  name               = join("-", concat([var.cluster_full_name, "argocd"]))
  tags               = var.aws_tags
}

data "aws_iam_policy_document" "argocd_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.argocd_service_account_role_arn]
    }
  }
}

data "aws_eks_cluster" "this" {
  name = var.cluster_full_name
}
