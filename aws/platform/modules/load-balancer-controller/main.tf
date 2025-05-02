resource "helm_release" "this" {
  chart      = coalesce(var.chart_name, local.chart_defaults.chart)
  name       = var.name
  namespace  = var.k8s_namespace
  repository = coalesce(var.chart_repository, local.chart_defaults.repository)
  values     = concat(local.chart_values, var.chart_values)
  version    = coalesce(var.chart_version, local.chart_defaults.version)

  # Ensure the role isn't detached until the chart is uninstalled. This prevents
  # target group bindings from being orphaned when the finalizer is missing
  # permissions.
  depends_on = [aws_iam_role_policy_attachment.this]
}

resource "helm_release" "ingress_config" {
  chart     = "${path.module}/target-group-binding"
  name      = var.ingress_config_release_name
  namespace = var.k8s_namespace

  values = [
    yamlencode({
      name = "istio-ingress"

      networking = {
        ingress = [
          {
            from = [
              {
                ipBlock = {
                  cidr = var.vpc_cidr_block
                }
              },
            ]
            ports = [
              { port = 15021 },
              { port = 80 },
              { port = 443 },
            ]
          }
        ]
      }

      serviceRef = {
        name = "flightdeck-ingressgateway"
        port = 443
      }

      targetGroupARN = data.aws_lb_target_group.this.arn
    })
  ]

  depends_on = [helm_release.this]
}

data "aws_lb_target_group" "this" {
  name = coalesce(var.target_group_name, var.cluster_full_name)
}

module "service_account_role" {
  source = "../../../service-account-role"

  name             = var.service_account_name
  namespace        = var.aws_namespace
  oidc_issuers     = [var.oidc_issuer]
  service_accounts = ["${var.k8s_namespace}:aws-${var.service_account_name}"]
  tags             = var.aws_tags
}

resource "aws_iam_policy" "this" {
  name   = module.service_account_role.name
  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = module.service_account_role.name
  policy_arn = aws_iam_policy.this.arn
}

locals {
  chart_defaults = jsondecode(file("${path.module}/chart.json"))

  chart_values = [
    yamlencode({
      clusterName = var.cluster_full_name

      serviceAccount = {
        name = "aws-${var.service_account_name}"

        annotations = {
          "eks.amazonaws.com/role-arn" = module.service_account_role.arn
        }
      }
    })
  ]
}
