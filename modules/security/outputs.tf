output "key_vault_id" {
  value = azurerm_key_vault.security_kv.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.security_kv.vault_uri
}
