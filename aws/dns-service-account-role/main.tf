module "dns_service_account_role" {
  source = "../aws-service-account-role"

  name        = "dns"
  namespace   = var.aws_namespace
  oidc_issuer = var.oidc_issuer
  policy_json = data.aws_iam_policy_document.dns_service_account_role.json
  tags        = var.aws_tags

  service_accounts = [
    "${var.k8s_namespace}:cert-manager",
    "${var.k8s_namespace}:external-dns"
  ]
}

data "aws_iam_policy_document" "dns_service_account_role" {
  statement {
    actions = [
      "route53:GetChange"
    ]
    resources = [
      "arn:aws:route53:::change/*"
    ]
  }
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]
    resources = [
      for zone_id in var.route53_zone_ids :
      "arn:aws:route53:::hostedzone/${zone_id}"
    ]
  }
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName"
    ]
    resources = ["*"]
  }
}
