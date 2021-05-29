locals {
  base         = var.name
  full         = join("-", concat(var.namespace, [local.base]))
  private_tags = { "kubernetes.io/role/internal-elb" = "1" }
  public_tags  = { "kubernetes.io/role/elb" = "1" }
  shared_tags  = { ("kubernetes.io/cluster/${local.full}") = "shared" }
}
