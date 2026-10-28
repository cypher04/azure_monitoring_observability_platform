output "key_vault_id" {
  value = azurerm_key_vault.security-kv.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.security-kv.vault_uri
}
