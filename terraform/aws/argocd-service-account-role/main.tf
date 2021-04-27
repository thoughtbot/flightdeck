module "argocd_service_account_role" {
  source = "../aws-service-account-role"

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
    actions   = ["sts:AssumeRole", "sts:AssumeRoleWithWebIdentity"]
    resources = var.cluster_role_arns
  }
}

