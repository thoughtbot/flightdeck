module "argocd_service_account_role" {
  source = "../service-account-role"

  name        = "argocd"
  namespace   = var.aws_namespace
  oidc_issuer = var.oidc_issuer
  policy_json = data.aws_iam_policy_document.argocd_service_account_role.json
  tags        = var.aws_tags

  service_accounts = [
    "${var.k8s_namespace}:argocd-server",
    "${var.k8s_namespace}:argocd-application-controller"
  ]
}

data "aws_iam_policy_document" "argocd_service_account_role" {
  statement {
    sid       = "GetCallerIdentity"
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(var.cluster_configs) == 0 ? [] : [true]

    content {
      sid       = "AssumeDeployRole"
      actions   = ["sts:AssumeRole", "sts:AssumeRoleWithWebIdentity"]
      resources = var.cluster_configs.*.config.awsAuthConfig.roleARN
    }
  }
}

resource "kubernetes_secret" "cluster" {
  for_each = var.cluster_configs

  metadata {
    name      = each.value.awsAuthConfig.clusterName
    namespace = var.k8s_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = each.value
}
