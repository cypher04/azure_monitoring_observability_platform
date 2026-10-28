resource "azurerm_resource_group" "security-rg" {
  name     = "security-rg"
  location = var.location
}


data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "security-kv" {
  name                        = "security-kv"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.security-rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  rbac_authorization_enabled = true
  enabled_for_disk_encryption = true
  public_network_access_enabled = true
  network_acls {
    default_action = "Allow"
    bypass = "AzureServices"
  }
}


resource "random_password" "security-kv-password" {
  length  = 16
  special = true
  upper = false
}

resource "azurerm_key_vault_secret" "security-kv-secret" {
  name         = "security-kv-secret"
  value        = random_password.security-kv-password.result
  key_vault_id = azurerm_key_vault.security-kv.id
  depends_on = [azurerm_role_assignment.security-kv-reader]
}

resource "azurerm_role_assignment" "security-kv-reader" {
  scope                = azurerm_key_vault.security-kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
  depends_on           = [azurerm_key_vault.security-kv]
}

