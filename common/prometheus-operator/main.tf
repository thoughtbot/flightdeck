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

      grafana = {
        enabled = false
      }
      kubeControllerManager = {
        enabled = false
      }
      kubeEtcd = {
        enabled = false
      }
      kubeProxy = {
        enabled = false
      }
      kubeScheduler = {
        enabled = false
      }
      prometheus = {
        additionalPodMonitors = [
          yamldecode(file("${path.module}/istio-podmonitor.yaml"))
        ]
        additionalServiceMonitors = [
          yamldecode(file("${path.module}/istio-servicemonitor.yaml"))
        ]
        prometheusSpec = {
          podMonitorSelector                      = {}
          podMonitorSelectorNilUsesHelmValues     = false
          ruleSelector                            = {}
          ruleSelectorNilUsesHelmValues           = false
          serviceMonitorSelector                  = {}
          serviceMonitorSelectorNilUsesHelmValues = false

          containers = [
            {
              name = "prometheus"
              readinessProbe = {
                failureThreshold = 250
              }
            },
          ]

          podMetadata = {
            annotations = {
              # https://github.com/istio/istio/issues/33188
              "traffic.sidecar.istio.io/excludeOutboundPorts" = "9093"
            }
          }

          retention = "24h"
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
