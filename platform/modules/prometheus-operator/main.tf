resource "helm_release" "this" {
  chart      = coalesce(var.chart_name, local.chart_defaults.chart)
  name       = var.name
  namespace  = var.k8s_namespace
  repository = coalesce(var.chart_repository, local.chart_defaults.repository)
  values     = concat(local.chart_values, var.chart_values)
  version    = coalesce(var.chart_version, local.chart_defaults.version)
}

resource "helm_release" "config" {
  chart     = "${path.module}/config"
  name      = "${var.name}-config"
  namespace = var.k8s_namespace
  values    = concat(local.chart_values, var.chart_values, local.config_values)
}

locals {
  chart_defaults = jsondecode(file("${path.module}/chart.json"))

  pagerduty_route = var.pagerduty_routing_key == null ? null : "pagerduty"
  opsgenie_route  = var.opsgenie_api_key == null ? null : "opsgenie"

  chart_values = [
    yamlencode({
      additionalPrometheusRulesMap = {
        workloads = yamldecode(file("${path.module}/workload-rules.yaml"))
      }
      alertmanager = {
        config = {
          receivers = concat(
            [{ name = "null" }],
            (
              var.pagerduty_routing_key == null ?
              [] :
              [
                {
                  name = "pagerduty"
                  pagerduty_configs = [
                    {
                      routing_key = var.pagerduty_routing_key
                    }
                  ]
                }
              ]
            ),
            (
              var.opsgenie_api_key == null ?
              [] :
              [
                {
                  name = "opsgenie"
                  opsgenie_configs = [
                    {
                      api_key = var.opsgenie_api_key
                    }
                  ]
                }
              ]
            )
          )

          route = {
            receiver = "null"

            routes = [
              {
                receiver = coalesce(local.pagerduty_route, local.opsgenie_route, "null")
                matchers = [
                  "severity =~ \"critical\""
                ]
              }
            ]
          }
        }
      }

      # Don't deploy an in-cluster Grafana
      grafana = {
        enabled = false
      }

      # Disable monitoring of resources managed by cloud (EKS, AKS, etc)
      kubeApiServer = {
        enabled = false
      }
      kubeControllerManager = {
        enabled = false
      }
      kubeEtcd = {
        enabled = false
      }
      kubelet = {
        enabled = true
      }
      kubeProxy = {
        enabled = false
      }
      kubeScheduler = {
        enabled = false
      }

      prometheus = {
        prometheusSpec = {
          podMetadata = {
            annotations = {
              # https://github.com/istio/istio/issues/33188
              "traffic.sidecar.istio.io/excludeOutboundPorts" = "9093"
            }
          }

          replicaExternalLabelNameClear = true
          replicas                      = 2
          retention                     = "24h"

          resources = {
            requests = {
              cpu    = "50m"
              memory = "256Mi"
            }
          }
        }
      }
      prometheusOperator = {
        admissionWebhooks = {
          certManager = {
            enabled = true
          }
        }
      }
    })
  ]

  config_values = [yamlencode({
    kubePrometheusStackRelease = helm_release.this.name
  })]
}
