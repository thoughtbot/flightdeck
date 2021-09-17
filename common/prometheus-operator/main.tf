resource "helm_release" "this" {
  chart      = var.chart_name
  name       = var.name
  namespace  = var.k8s_namespace
  repository = var.chart_repository
  values     = concat(local.chart_values, var.chart_values)
  version    = var.chart_version
}

locals {
  chart_values = [
    yamlencode({
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
            )
          )

          route = {
            receiver = var.pagerduty_routing_key == null ? "null" : "pagerduty"
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
        enabled = false
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

          retention = "24h"

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
}
