locals {
  download_uri = join("/", [
    var.download_base_uri,
    var.istio_version,
    "istio-${var.istio_version}-${var.os}-${var.arch}.tar.gz"
  ])
  chart_path = "${abspath(path.module)}/${null_resource.charts.id}/istio-${var.istio_version}/manifests/charts"
}

resource "null_resource" "charts" {
  provisioner "local-exec" {
    command     = "${abspath(path.module)}/download.sh"
    working_dir = path.module

    environment = {
      ARCHIVE_ID    = self.id
      ISTIO_URL     = local.download_uri
      ISTIO_VERSION = var.istio_version
    }
  }

  triggers = {
    archive = fileexists("istio.tar.gz") ? filesha256("istio.tar.gz") : timestamp()
    script  = filesha256("${path.module}/download.sh")
    url     = local.download_uri
    version = var.istio_version
  }
}
