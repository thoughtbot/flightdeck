resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "enabled"
    }

    name = var.name
  }
}
