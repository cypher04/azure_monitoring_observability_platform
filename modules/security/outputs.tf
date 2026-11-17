output "key_vault_id" {
  value = azurerm_key_vault.security-kv.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.security-kv.vault_uri
}


output "sql_admin_username" {
  value = azurerm_key_vault_secret.sql_admin_username.value
}

output "sql_admin_password" {
  value = azurerm_key_vault_secret.sql_admin_password.value
}