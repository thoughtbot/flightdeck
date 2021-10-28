resource "kubernetes_namespace" "istio" {
  metadata {
    name = var.istio_namespace
  }
}

module "istio" {
  source = "../../common/istio"

  discovery_chart_values = var.istio_discovery_values
  istio_version          = var.istio_version
  k8s_namespace          = kubernetes_namespace.istio.metadata[0].name
}

module "ingress_config" {
  source = "../../common/ingress-config"

  domain_names  = var.domain_names
  issuer        = var.certificate_issuer
  k8s_namespace = local.flightdeck_namespace

  depends_on = [module.cert_manager, module.istio]
}

resource "kubernetes_namespace" "flightdeck" {
  metadata {
    name = var.flightdeck_namespace

    labels = {
      "istio-injection" = "enabled"
    }
  }

  depends_on = [module.istio]
}

module "cert_manager" {
  source = "../../common/cert-manager"

  chart_values  = var.cert_manager_values
  chart_version = var.cert_manager_version
  k8s_namespace = local.flightdeck_namespace
}

module "cluster_autoscaler" {
  source = "../../common/cluster-autoscaler"

  chart_values  = var.cluster_autoscaler_values
  chart_version = var.cluster_autoscaler_version
  k8s_namespace = local.flightdeck_namespace
}

module "external_dns" {
  source = "../../common/external-dns"

  count = var.external_dns_enabled ? 1 : 0

  chart_values  = var.external_dns_values
  chart_version = var.external_dns_version
  k8s_namespace = local.flightdeck_namespace
}

module "fluent_bit" {
  source = "../../common/fluent-bit"

  chart_values                  = var.fluent_bit_values
  chart_version                 = var.fluent_bit_version
  enable_kubernetes_annotations = var.fluent_bit_enable_kubernetes_annotations
  enable_kubernetes_labels      = var.fluent_bit_enable_kubernetes_labels
  k8s_namespace                 = local.flightdeck_namespace

  depends_on = [module.prometheus_operator]
}

module "istio_ingress" {
  source = "../../common/istio-ingress"

  chart_values  = var.istio_ingress_values
  istio_version = var.istio_version
  k8s_namespace = local.flightdeck_namespace
}

resource "kubernetes_namespace" "kube_prometheus_stack" {
  metadata {
    name = "kube-prometheus-stack"

    labels = {
      "istio-injection" = "enabled"
    }
  }

  depends_on = [module.istio]
}

module "prometheus_operator" {
  source = "../../common/prometheus-operator"

  chart_values          = var.prometheus_operator_values
  chart_version         = var.prometheus_operator_version
  k8s_namespace         = local.kube_prometheus_stack_namespace
  pagerduty_routing_key = var.pagerduty_routing_key

  depends_on = [module.cert_manager]
}

module "prometheus_adapter" {
  source = "../../common/prometheus-adapter"

  chart_version = var.prometheus_adapter_version
  k8s_namespace = local.kube_prometheus_stack_namespace

  chart_values = concat(
    local.prometheus_adapter_values,
    var.prometheus_adapter_values
  )

  depends_on = [module.prometheus_operator]
}

module "flightdeck_prometheus" {
  source = "../../common/prometheus-instance"

  chart_values  = local.flightdeck_prometheus_values
  k8s_namespace = local.kube_prometheus_stack_namespace
  name          = "flightdeck-prometheus"

  depends_on = [module.prometheus_operator]
}

module "federated_prometheus" {
  source = "../../common/prometheus-instance"

  chart_values  = local.federated_prometheus_values
  k8s_namespace = local.kube_prometheus_stack_namespace
  name          = "federated-prometheus"

  depends_on = [module.prometheus_operator]
}

module "secret_store_driver" {
  source = "../../common/secret-store-driver"

  chart_values  = var.secret_store_driver_values
  chart_version = var.secret_store_driver_version
  k8s_namespace = "kube-system"
}

module "metrics_server" {
  source = "../../common/metrics-server"

  chart_values  = var.metrics_server_values
  chart_version = var.metrics_server_version
  k8s_namespace = local.flightdeck_namespace
}

module "vertical_pod_autoscaler" {
  source = "../../common/vertical-pod-autoscaler"

  chart_values  = var.vertical_pod_autoscaler_values
  k8s_namespace = local.flightdeck_namespace

  depends_on = [module.cert_manager]
}

module "reloader" {
  source = "../../common/reloader"

  chart_values  = var.reloader_values
  chart_version = var.reloader_version
  k8s_namespace = local.flightdeck_namespace
}

module "sloth" {
  source = "../../common/sloth"

  depends_on = [module.prometheus_operator]
}

locals {
  flightdeck_namespace            = kubernetes_namespace.flightdeck.metadata[0].name
  kube_prometheus_stack_namespace = kubernetes_namespace.kube_prometheus_stack.metadata[0].name

  federated_prometheus_values = concat(
    [file("${path.module}/federated-prometheus.yaml")],
    var.federated_prometheus_values
  )

  flightdeck_prometheus_values = concat(
    [file("${path.module}/flightdeck-prometheus.yaml")],
    var.flightdeck_prometheus_values
  )

  prometheus_adapter_values = [
    yamlencode({
      prometheus = {
        port = 9090
        url  = "http://flightdeck-prometheus.${local.kube_prometheus_stack_namespace}.svc"
      }
    })
  ]
}
