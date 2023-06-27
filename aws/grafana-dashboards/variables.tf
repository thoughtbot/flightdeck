variable "dashboards_to_create" {
  description = "List of dashboards to create (cluster-resources, istio, rds-databases, slo-details, and/or slo-overview)"
  type        = list(string)

  validation {
    condition = length(setsubtract(
      var.dashboards_to_create,
      ["cluster-resources", "istio", "rds-databases", "slo-details", "slo-overview"],
    )) == 0
    error_message = "Valid options for dashboards to create are: cluster-resources, istio, rds-databases, slo-details, slo-overview"
  }

  validation {
    condition     = length(var.dashboards_to_create) > 0
    error_message = "At least one dashboard must be selected"
  }
}
