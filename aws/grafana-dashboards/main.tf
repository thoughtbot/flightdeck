resource "grafana_dashboard" "this" {
  for_each = toset(var.dashboards_to_create)

  config_json = file("${path.module}/dashboards/${each.value}.json")

  lifecycle {
    ignore_changes = [
      config_json
    ]
  }
}
