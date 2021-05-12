output "cert_manager_values" {
  description = "AWS-specific values for cert-manager"
  value = [
    yamlencode({
      securityContext = {
        # https://github.com/jetstack/cert-manager/issues/2147
        fsGroup = 1001
      }
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.dns_service_account_role.arn
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
