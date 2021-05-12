output "client_secrets" {
  description = "OAuth2 secret for each static client"

  value = zipmap(
    keys(random_password.client),
    values(random_password.client).*.result
  )
}
