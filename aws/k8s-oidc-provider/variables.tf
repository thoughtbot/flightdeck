variable "cluster" {
  description = "Cluster providing an OpenID connect issuer"
  type = object({
    identity = list(object({ oidc = list(object({ issuer = string })) }))
  })
}
