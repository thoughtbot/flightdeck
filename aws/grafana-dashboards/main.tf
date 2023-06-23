resource "grafana_dashboard" "istio" {
  count = var.create_istio_dashboard ? 1 : 0

  config_json = file("${path.module}/dashboards/istio.json")
}
