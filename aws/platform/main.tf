module "common_platform" {
  source = "../../platform"

  certificate_issuer                       = var.certificate_issuer
  domain_names                             = var.domain_names
  external_dns_enabled                     = var.external_dns_enabled
  fluent_bit_enable_kubernetes_annotations = var.fluent_bit_enable_kubernetes_annotations
  fluent_bit_enable_kubernetes_labels      = var.fluent_bit_enable_kubernetes_labels
  istio_base_values                        = var.istio_base_values
  istiod_values                            = var.istiod_values
  metrics_server_values                    = var.metrics_server_values
  metrics_server_version                   = var.metrics_server_version
  pagerduty_routing_key                    = local.pagerduty_routing_key
  opsgenie_api_key                         = local.opsgenie_api_key
  prometheus_adapter_values                = var.prometheus_adapter_values
  reloader_values                          = var.reloader_values
  reloader_version                         = var.reloader_version
  secret_store_driver_values               = var.secret_store_driver_values
  secret_store_driver_version              = var.secret_store_driver_version
  vertical_pod_autoscaler_values           = var.vertical_pod_autoscaler_values

  cert_manager_values = concat(
    local.cert_manager_values,
    var.cert_manager_values
  )

  cluster_autoscaler_values = concat(
    local.cluster_autoscaler_values,
    var.cluster_autoscaler_values
  )

  external_dns_values = concat(
    local.external_dns_values,
    var.external_dns_values
  )

  federated_prometheus_values = concat(
    local.federated_prometheus_values,
    var.federated_prometheus_values
  )

  flightdeck_prometheus_values = concat(
    local.flightdeck_prometheus_values,
    var.flightdeck_prometheus_values
  )

  fluent_bit_values = concat(
    local.fluent_bit_values,
    var.fluent_bit_values
  )

  istio_ingress_values = concat(
    local.istio_ingress_values,
    var.istio_ingress_values
  )

  prometheus_operator_values = concat(
    local.prometheus_operator_values,
    var.prometheus_operator_values
  )

  depends_on = [
    module.prometheus_service_account_role,
    module.ebs_csi_driver_service_account_role,
    module.aws_ebs_csi_driver
  ]
}

module "aws_load_balancer_controller" {
  source = "./modules/load-balancer-controller"

  aws_namespace     = [module.cluster_name.full]
  aws_tags          = var.aws_tags
  chart_values      = var.aws_load_balancer_controller_values
  chart_version     = var.aws_load_balancer_controller_version
  cluster_full_name = module.cluster_name.full
  k8s_namespace     = var.k8s_namespace
  oidc_issuer       = data.aws_ssm_parameter.oidc_issuer.value
  vpc_cidr_block    = module.network.vpc.cidr_block
  vpc_id            = module.network.vpc.id

  depends_on = [module.common_platform]
}

module "cluster_name" {
  source = "../cluster-name"

  name      = var.cluster_name
  namespace = var.aws_namespace
}

module "network" {
  source = "../network-data"

  private_tags = module.cluster_name.private_tags
  public_tags  = module.cluster_name.public_tags
  tags         = module.cluster_name.shared_tags
}

module "auth_config_map" {
  source = "./modules/auth-config-map"

  admin_roles       = var.admin_roles
  cluster_full_name = module.cluster_name.full
  custom_roles      = var.custom_roles
  custom_groups     = var.custom_groups
  node_roles        = concat(local.node_roles, var.node_roles)
}

module "dns_service_account_role" {
  source = "./modules/dns-service-account-role"

  aws_namespace    = [module.cluster_name.full]
  aws_tags         = var.aws_tags
  k8s_namespace    = var.k8s_namespace
  oidc_issuer      = data.aws_ssm_parameter.oidc_issuer.value
  route53_zone_ids = values(data.aws_route53_zone.managed)[*].id
}

module "cloudwatch_logs" {
  source = "./modules/cloudwatch-logs"

  aws_namespace     = [module.cluster_name.full]
  aws_tags          = var.aws_tags
  cluster_full_name = module.cluster_name.full
  k8s_namespace     = var.k8s_namespace
  log_group_prefix  = var.logs_prefix
  oidc_issuer       = data.aws_ssm_parameter.oidc_issuer.value
  retention_in_days = var.logs_retention_in_days
  skip_destroy      = var.logs_skip_destroy
}

module "cluster_autoscaler_service_account_role" {
  source = "./modules/cluster-autoscaler-service-account-role"

  aws_namespace = [module.cluster_name.full]
  aws_tags      = var.aws_tags
  k8s_namespace = var.k8s_namespace
  oidc_issuer   = data.aws_ssm_parameter.oidc_issuer.value
}

module "prometheus_service_account_role" {
  count  = var.prometheus_data_source["name"] == null ? 0 : 1
  source = "./modules/prometheus-service-account-role"

  aws_namespace        = [module.cluster_name.full]
  aws_tags             = var.aws_tags
  k8s_namespace        = "kube-prometheus-stack"
  oidc_issuer          = data.aws_ssm_parameter.oidc_issuer.value
  workspace_account_id = local.monitoring_account_id
  workspace_name       = var.prometheus_data_source["name"]
}

module "ebs_csi_driver_service_account_role" {
  source = "./modules/ebs-csi-driver-service-account-role"

  aws_namespace = [module.cluster_name.full]
  aws_tags      = var.aws_tags
  k8s_namespace = "kube-system"
  oidc_issuer   = data.aws_ssm_parameter.oidc_issuer.value
}

module "aws_ebs_csi_driver" {
  source = "./modules/aws-ebs-csi-driver"

  chart_version = var.aws_ebs_csi_driver_version
  k8s_namespace = "kube-system"

  chart_values = concat(
    local.aws_ebs_csi_driver_values,
    var.aws_ebs_csi_driver_values
  )
}

module "secrets_store_provider" {
  source = "./modules/secrets-store-provider"

  chart_values = var.secret_store_provider_values
}

data "aws_route53_zone" "managed" {
  for_each = toset(var.hosted_zones)

  name = each.value
}

data "aws_ssm_parameter" "node_role_arn" {
  name = join("/", concat(
    [""],
    ["flightdeck", module.cluster_name.full, "node_role_arn"]
  ))
}

data "aws_ssm_parameter" "oidc_issuer" {
  name = join("/", concat(
    [""],
    ["flightdeck", module.cluster_name.full, "oidc_issuer"]
  ))
}

data "aws_ssm_parameter" "pagerduty_routing_key" {
  count = var.pagerduty_parameter == null ? 0 : 1

  name = var.pagerduty_parameter
}

data "aws_ssm_parameter" "opsgenie_api_key" {
  count = var.opsgenie_parameter == null ? 0 : 1

  name = var.opsgenie_parameter
}

data "aws_caller_identity" "this" {}

data "aws_region" "current" {}

locals {
  aws_ebs_csi_driver_values = [
    yamlencode({
      controller = {
        serviceAccount = {
          create = true
          name   = "ebs-csi-controller-sa"
          annotations = {
            "eks.amazonaws.com/role-arn" = module.ebs_csi_driver_service_account_role.arn
          }
        }
        replicaCount = 2
      }
      node = {
        serviceAccount = {
          create = false
          name   = "ebs-csi-controller-sa"
          annotations = {
            "eks.amazonaws.com/role-arn" = module.ebs_csi_driver_service_account_role.arn
          }
        }
      }
    })
  ]

  cert_manager_values = [
    yamlencode({
      extraArgs = [
        # Allow Issuers to use IRSA credentials
        "--issuer-ambient-credentials"
      ]
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.dns_service_account_role.arn
        }
      }
    })
  ]

  cluster_autoscaler_values = [
    yamlencode({
      autoDiscovery = {
        clusterName = module.cluster_name.full
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

  external_dns_values = [
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

  federated_prometheus_values = concat(
    (
      var.prometheus_data_source["host"] == null ?
      [] :
      [
        yamlencode({
          serviceAccount = {
            annotations = {
              "eks.amazonaws.com/role-arn" = join("", module.prometheus_service_account_role[*].arn)
            }
          }
          prometheus = {
            spec = {
              # This sidecar container can be replaced on Sigv4 support is merged
              # https://github.com/prometheus-operator/prometheus-operator/issues/3987
              containers = [
                {
                  args = [
                    "--name",
                    "aps",
                    "--region",
                    var.prometheus_data_source["region"],
                    "--host",
                    var.prometheus_data_source["host"],
                    "--port",
                    ":8005",
                    "--role-arn",
                    var.prometheus_data_source["role_arn"]
                  ]
                  name  = "sigv4-proxy"
                  image = "public.ecr.aws/aws-observability/aws-sigv4-proxy:1.0"
                  ports = [
                    {
                      containerPort = 8005
                      name          = "aws-sigv4-proxy"
                    }
                  ]
                }
              ]
              externalLabels = {
                cluster = var.cluster_name
              }
              remoteWrite = [
                {
                  queueConfig = {
                    capacity          = 2500
                    maxSamplesPerSend = 1000
                    maxShards         = 200
                  }
                  url = "http://localhost:8005/${var.prometheus_data_source["write_path"]}"
                }
              ]
            }
          }
        })
      ]
    ),
    var.federated_prometheus_values
  )

  flightdeck_prometheus_values = [
    yamlencode({
      prometheus = {
        spec = {
          retentionSize = "8GB"
          storage = {
            volumeClaimTemplate = {
              spec = {
                resources = {
                  requests = {
                    storage = "10Gi"
                  }
                }
                storageClassName = "gp2"
              }
            }
          }
        }
      }
    })
  ]

  fluent_bit_values = [
    yamlencode({
      config = {
        outputs = <<-EOT
        [OUTPUT]
            Name cloudwatch_logs
            Match *
            auto_create_group true
            region ${data.aws_region.current.name}
            log_group_name ${module.cloudwatch_logs.log_group_name}
            log_group_template ${var.logs_prefix}/$kubernetes['namespace_name']
            log_stream_prefix $${HOST_NAME}-
            log_stream_template $kubernetes['pod_name'].$kubernetes['container_name']
            log_retention_days ${var.logs_retention_in_days}
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
        tag        = "2.31.6"
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

  istio_ingress_values = [
    yamlencode({
      service = {
        type = "ClusterIP"
      }
    })
  ]

  monitoring_account_id = coalesce(
    var.monitoring_account_id,
    data.aws_caller_identity.this.account_id
  )

  node_roles = [data.aws_ssm_parameter.node_role_arn.value]

  pagerduty_routing_key = (
    var.pagerduty_parameter == null ?
    null :
    join("", data.aws_ssm_parameter.pagerduty_routing_key[*].value)
  )

  opsgenie_api_key = (
    var.opsgenie_parameter == null ?
    null :
    join("", data.aws_ssm_parameter.opsgenie_api_key[*].value)
  )

  prometheus_operator_values = concat(
    [
      yamlencode({
        prometheus = {
          prometheusSpec = {
            retentionSize = "8GB"
            storageSpec = {
              volumeClaimTemplate = {
                spec = {
                  resources = {
                    requests = {
                      storage = "10Gi"
                    }
                  }
                  storageClassName = "gp2"
                }
              }
            }
          }
        }
      })
    ]
  )
}
