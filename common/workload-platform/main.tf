resource "kubernetes_namespace" "istio" {
  metadata {
    name = var.istio_namespace
  }
}

module "istio" {
  source = "../../common/istio"

  chart_version = var.istio_version
  k8s_namespace = kubernetes_namespace.istio.metadata[0].name
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
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name
}

module "cluster_autoscaler" {
  source = "../../common/cluster-autoscaler"

  chart_values  = var.cluster_autoscaler_values
  chart_version = var.cluster_autoscaler_version
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name
}

module "external_dns" {
  source = "../../common/external-dns"

  chart_values  = var.external_dns_values
  chart_version = var.external_dns_version
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name
}

module "istio_ingress" {
  source = "../../common/istio-ingress"

  chart_values  = var.istio_ingress_values
  chart_version = var.istio_version
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name
}
