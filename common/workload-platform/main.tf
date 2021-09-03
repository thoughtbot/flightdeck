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
  k8s_namespace = var.flightdeck_namespace

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
  k8s_namespace = local.k8s_namespace
}

module "cluster_autoscaler" {
  source = "../../common/cluster-autoscaler"

  chart_values  = var.cluster_autoscaler_values
  chart_version = var.cluster_autoscaler_version
  k8s_namespace = local.k8s_namespace
}

module "external_dns" {
  source = "../../common/external-dns"

  count = var.external_dns_enabled ? 1 : 0

  chart_values  = var.external_dns_values
  chart_version = var.external_dns_version
  k8s_namespace = local.k8s_namespace
}

module "fluent_bit" {
  source = "../../common/fluent-bit"

  chart_values                  = var.fluent_bit_values
  chart_version                 = var.fluent_bit_version
  enable_kubernetes_annotations = var.fluent_bit_enable_kubernetes_annotations
  enable_kubernetes_labels      = var.fluent_bit_enable_kubernetes_labels
  k8s_namespace                 = local.k8s_namespace

  depends_on = [module.prometheus_operator]
}

module "istio_ingress" {
  source = "../../common/istio-ingress"

  chart_values  = var.istio_ingress_values
  istio_version = var.istio_version
  k8s_namespace = local.k8s_namespace
}

module "prometheus_operator" {
  source = "../../common/prometheus-operator"

  chart_values          = var.prometheus_operator_values
  chart_version         = var.prometheus_operator_version
  k8s_namespace         = local.k8s_namespace
  pagerduty_routing_key = var.pagerduty_routing_key

  depends_on = [module.cert_manager]
}

module "prometheus_adapter" {
  source = "../../common/prometheus-adapter"

  chart_values  = var.prometheus_adapter_values
  chart_version = var.prometheus_adapter_version
  k8s_namespace = local.k8s_namespace

  depends_on = [module.prometheus_operator]
}

locals {
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name
}
