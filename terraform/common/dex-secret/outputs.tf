output "client_secrets" {
  description = "OAuth2 secret for each static client"
  value       = zipmap(var.clients, values(random_password.client).*.result)
}
