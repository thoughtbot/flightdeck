output "issuer" {
  description = "Hostname of the OpenID Connect issuer"
  value       = trimprefix(var.cluster.identity.0.oidc.0.issuer, "https://")
}
