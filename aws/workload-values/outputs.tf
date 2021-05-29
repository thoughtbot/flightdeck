output "cert_manager_values" {
  description = "AWS-specific values for cert-manager"
  value = [
    yamlencode({
      extraArgs = [
        # Allow Issuers to use IRSA credentials
        "--issuer-ambient-credentials"
      ]
      securityContext = {
        # https://github.com/jetstack/cert-manager/issues/2147
        enabled = true
      }
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.dns_service_account_role.arn
        }
      }
    })
  ]
}

output "cluster_autoscaler_values" {
  description = "AWS-specific values for cluster-autoscaler"
  value = [
    yamlencode({
      autoDiscovery = {
        clusterName = var.cluster_full_name
      }
      awsRegion = data.aws_region.current.name
      rbac = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = module.cluster_autoscaler_service_account_role.arn
          }
        }
      }
    })
  ]
}

output "external_dns_values" {
  description = "AWS-specific values for external-dns"
  value = [
    yamlencode({
      aws = {
        region = data.aws_region.current.name
      }
      domainFilters = var.domain_filters
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.dns_service_account_role.arn
        }
      }
    })
  ]
}

output "oidc_issuer" {
  description = "OIDC issuer configured for this cluster"
  value       = data.aws_ssm_parameter.oidc_issuer.value
}

output "prometheus_operator_values" {
  description = "AWS-specific values for Prometheus Operator"
  value = [
    yamlencode({
      retentionSize = "30GB"
      storageSpec = {
        volumeClaimTemplate = {
          spec = {
            resources = {
              requests = {
                storage = "40Gi"
              }
            }
            storageClassName = "gp2"
          }
        }
      }
    })
  ]
}

