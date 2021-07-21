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

output "certificate_solvers" {
  description = "AWS certificate solvers using Route 53 dns01 challenge"
  value       = local.certificate_solvers
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
      domainFilters = var.hosted_zones
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.dns_service_account_role.arn
        }
      }
    })
  ]
}

output "fluent_bit_values" {
  description = "AWS-specific values for Fluent Bit"
  value = [
    yamlencode({
      config = {
        outputs = <<-EOT
        [OUTPUT]
            Name cloudwatch_logs
            Match *
            region ${data.aws_region.current.name}
            log_group_name ${module.cloudwatch_logs.log_group_name}
            log_stream_prefix $${HOST_NAME}-
        EOT
      }
      env = [
        {
          name = "HOST_NAME"
          valueFrom = {
            fieldRef = {
              fieldPath = "spec.nodeName"
            }
          }
        },
      ]
      image = {
        repository = "public.ecr.aws/aws-observability/aws-for-fluent-bit"
        tag        = "2.12.0"
      }
      resources = {
        limits = {
          memory = "128Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
      }
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.cloudwatch_logs.service_account_role_arn
        }
      }
      serviceMonitor = {
        enabled = true
      }
    })
  ]
}

output "oidc_issuer" {
  description = "OIDC issuer configured for this cluster"
  value       = data.aws_ssm_parameter.oidc_issuer.value
}

output "pagerduty_routing_key" {
  description = "Routing key for delivering alerts to Pagerduty"

  value = (
    var.pagerduty_parameter == null ?
    null :
    join("", data.aws_ssm_parameter.pagerduty_routing_key.*.value)
  )
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
