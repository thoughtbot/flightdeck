# AWS Managed Grafana Dashboards

Adds the option to create some basic dashboards.

Example:

```terraform
module "grafana_dashboards" {
  source = "github.com/thoughtbot/flightdeck//aws/grafana-datashboards?ref=VERSION"

  create_istio_dashboard = true
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | ~> 1.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | ~> 1.13 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [grafana_dashboard.istio](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_istio_dashboard"></a> [create\_istio\_dashboard](#input\_create\_istio\_dashboard) | Create Istio dashboard | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->