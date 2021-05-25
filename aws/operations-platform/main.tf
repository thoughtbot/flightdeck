module "common_platform" {
  source = "../../common/operations-platform"

  argocd_github_repositories = var.argocd_github_repositories
  argocd_policy              = var.argocd_policy
  argocd_values              = concat(local.argocd_values, var.argocd_values)
  certificate_email          = var.certificate_email
  certificate_solvers        = local.certificate_solvers
  dex_extra_secrets          = var.dex_extra_secrets
  dex_values                 = var.dex_values
  host                       = var.host

  cert_manager_values = concat(
    module.workload_values.cert_manager_values,
    var.cert_manager_values
  )

  cluster_autoscaler_values = concat(
    module.workload_values.cluster_autoscaler_values,
    var.cluster_autoscaler_values
  )

  external_dns_values = concat(
    module.workload_values.external_dns_values,
    var.external_dns_values
  )
}

module "workload_values" {
  source = "../workload-values"

  aws_namespace  = var.aws_namespace
  aws_tags       = var.aws_tags
  cluster_name   = var.cluster_name
  domain_filters = var.domain_filters
  k8s_namespace  = var.k8s_namespace
}

module "argocd_service_account_role" {
  source = "../argocd-service-account-role"

  aws_namespace   = var.aws_namespace
  aws_tags        = var.aws_tags
  cluster_configs = local.cluster_configs
  k8s_namespace   = var.k8s_namespace
  oidc_issuer     = module.workload_values.oidc_issuer
}

module "config_bucket" {
  source = "../s3-bucket"

  name   = var.config_bucket
  policy = data.aws_iam_policy_document.config_bucket.json
  tags   = var.aws_tags
}

data "aws_iam_policy_document" "config_bucket" {
  statement {
    sid = "OperationsAdmin"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.config_bucket}",
      "arn:aws:s3:::${var.config_bucket}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  dynamic "statement" {
    for_each = var.workload_account_ids

    content {
      sid = "Workloads${statement.value}"
      actions = [
        "s3:PutObject",
        "s3:GetObject"
      ]
      resources = [
        "arn:aws:s3:::${var.config_bucket}/workload-clusters/*"
      ]
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${statement.value}:root"]
      }
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_object" "operations_config" {
  bucket       = module.config_bucket.name
  content_type = "application/json"
  key          = "operations.json"

  content = jsonencode({
    "argocd_service_account_role_arn" = module.argocd_service_account_role.arn
  })
}

data "aws_s3_bucket_object" "cluster_config" {
  for_each = toset(var.workload_cluster_names)

  bucket = module.config_bucket.name
  key    = "workload-clusters/${each.value}.json"
}

locals {
  account_id = data.aws_caller_identity.current.account_id

  argocd_values = [
    yamlencode({
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.argocd_service_account_role.arn
        }
      }
    })
  ]

  certificate_solvers = yamlencode([
    {
      dns01 = {
        route53 = {
          region = data.aws_region.current.name
        }
      }
      selector = {
        dnsZones = var.domain_filters
      }
    }
  ])

  cluster_configs = [
    for s3_object in data.aws_s3_bucket_object.cluster_config :
    jsondecode(s3_object.body)
  ]
}

data "aws_region" "current" {}
