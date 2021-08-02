resource "helm_release" "this" {
  chart      = var.chart_name
  name       = var.name
  namespace  = var.k8s_namespace
  repository = var.chart_repository
  values     = concat(local.chart_values, var.chart_values)
  version    = var.chart_version
}

resource "helm_release" "ingress_config" {
  chart     = "${path.module}/target-group-binding"
  name      = "target-group-binding"
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
              { port = 8080 },
              { port = 8443 },
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
}

data "aws_lb_target_group" "this" {
  name = coalesce(var.target_group_name, var.cluster_full_name)
}

module "service_account_role" {
  source = "../service-account-role"

  name             = "load-balancer-controller"
  namespace        = var.aws_namespace
  oidc_issuer      = var.oidc_issuer
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
