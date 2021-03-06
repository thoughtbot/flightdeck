module "dns_service_account_role" {
  source = "../../../service-account-role"

  name         = "dns"
  namespace    = var.aws_namespace
  oidc_issuers = [var.oidc_issuer]
  tags         = var.aws_tags

  service_accounts = [
    "${var.k8s_namespace}:cert-manager",
    "${var.k8s_namespace}:external-dns"
  ]
}

resource "aws_iam_policy" "this" {
  name   = module.dns_service_account_role.name
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = module.dns_service_account_role.name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "route53:GetChange"
    ]
    resources = [
      "arn:aws:route53:::change/*"
    ]
  }
  dynamic "statement" {
    for_each = length(var.route53_zone_ids) == 0 ? [] : [true]

    content {
      actions = [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ]
      resources = [
        for zone_id in var.route53_zone_ids :
        "arn:aws:route53:::hostedzone/${zone_id}"
      ]
    }
  }
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName"
    ]
    resources = ["*"]
  }
}
