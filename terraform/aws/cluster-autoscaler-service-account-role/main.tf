module "cluster_autoscaler_service_account_role" {
  source = "../aws-service-account-role"

  name             = "cluster-autoscaler"
  namespace        = var.aws_namespace
  oidc_issuer      = var.oidc_issuer
  policy_json      = data.aws_iam_policy_document.autoscaler_service_account_role.json
  service_accounts = ["${var.k8s_namespace}:cluster-autoscaler"]
  tags             = var.aws_tags
}

data "aws_iam_policy_document" "autoscaler_service_account_role" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
  }
}
