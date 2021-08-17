module "common_platform" {
  source = "../../common/operations-platform"

  dex_extra_secrets = var.dex_extra_secrets
  dex_values        = var.dex_values
  host              = var.host
}
