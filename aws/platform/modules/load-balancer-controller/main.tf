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

resource "kubernetes_manifest" "target_group_binding" {
  manifest = {
    apiVersion = "elbv2.k8s.aws/v1beta1"
    kind       = "TargetGroupBinding"

    metadata = {
      name      = "target-group-binding"
      namespace = var.k8s_namespace
    }

    spec = {
      targetGroupARN = data.aws_lb_target_group.this.arn
      targetType     = "ip"

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
    }
  }

  # Wait for the CRD to be defined before creating
  depends_on = [helm_release.this]
}

data "aws_lb_target_group" "this" {
  name = coalesce(var.target_group_name, var.cluster_full_name)
}

module "service_account_role" {
  source = "../../../service-account-role"

  name             = "load-balancer-controller"
  namespace        = var.aws_namespace
  oidc_issuers     = [var.oidc_issuer]
  service_accounts = ["${var.k8s_namespace}:aws-load-balancer-controller"]
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
        name = "aws-load-balancer-controller"

        annotations = {
          "eks.amazonaws.com/role-arn" = module.service_account_role.arn
        }
      }
    })
  ]
}
