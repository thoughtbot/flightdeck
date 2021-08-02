output "alb" {
  description = "The load balancer"
  value       = module.alb.instance
}

output "security_group" {
  description = "Security group for the load balancer"
  value       = module.alb.security_group
}

output "http_listener" {
  description = "The HTTP listener"
  value       = module.alb.instance
}

output "https_listener" {
  description = "The HTTPS listener"
  value       = module.alb.instance
}
