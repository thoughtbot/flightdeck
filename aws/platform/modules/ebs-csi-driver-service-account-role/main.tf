module "ebs_csi_driver_service_account_role" {
  source = "../../../service-account-role"

  name             = "ebs-csi-controller-sa"
  namespace        = var.aws_namespace
  oidc_issuers     = [var.oidc_issuer]
  service_accounts = ["${var.k8s_namespace}:ebs-csi-controller-sa"]
  tags             = var.aws_tags
}

resource "aws_iam_policy" "this" {
  name   = module.ebs_csi_driver_service_account_role.name
  policy = data.aws_iam_policy_document.ebs_csi_driver_encryption.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = module.ebs_csi_driver_service_account_role.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  role       = module.ebs_csi_driver_service_account_role.name
  policy_arn = "${local.policy_prefix}/service-role/AmazonEBSCSIDriverPolicy"
}

data "aws_iam_policy_document" "ebs_csi_driver_encryption" {
  statement {
    sid = "EncryptEbsStoragePolicy"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:CreateGrant"
    ]
    resources = ["*"]
  }
}

data "aws_partition" "current" {}

locals {
  policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
}
