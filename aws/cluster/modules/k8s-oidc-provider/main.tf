data "tls_certificate" "this" {
  url = var.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = var.cluster.identity[0].oidc[0].issuer
}
