module "cluster_autoscaler_service_account_role" {
  source = "../../../service-account-role"

  name             = "cluster-autoscaler"
  namespace        = var.aws_namespace
  oidc_issuers     = [var.oidc_issuer]
  service_accounts = ["${var.k8s_namespace}:cluster-autoscaler"]
  tags             = var.aws_tags
}

resource "aws_iam_policy" "this" {
  name   = module.cluster_autoscaler_service_account_role.name
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = module.cluster_autoscaler_service_account_role.name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy_document" "this" {
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
