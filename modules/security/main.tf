resource "azurerm_resource_group" "security-rg" {
  name     = "security-rg"
  location = var.location
}


data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "security-kv" {
  name                          = "security-kv-${random_string.security-kv-name.result}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.security-rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  enabled_for_disk_encryption   = true
  public_network_access_enabled = true
  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}


resource "random_string" "security-kv-name" {
  length  = 6
  special = false
  upper   = false
}

resource "random_password" "security-kv-password" {
  length  = 16
  special = true
  upper   = false
}

resource "random_string" "sql-admin-username" {
  length  = 8
  special = false
  upper   = false
}

resource "random_password" "sql-admin-password" {
  length      = 16
  special     = true
  upper       = false
  min_lower   = 1
  min_upper   = 1
  min_special = 1
}
resource "azurerm_key_vault_secret" "security-kv-secret" {
  name         = "security-kv-secret"
  value        = random_password.security-kv-password.result
  key_vault_id = azurerm_key_vault.security-kv.id
  depends_on   = [azurerm_role_assignment.security-kv-reader]
}

resource "azurerm_key_vault_secret" "sql_admin_username" {
  name         = "sql-admin-username"
  value        = "sql${random_string.sql-admin-username.result}"
  key_vault_id = azurerm_key_vault.security-kv.id
  depends_on   = [azurerm_role_assignment.security-kv-reader]
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = random_password.sql-admin-password.result
  key_vault_id = azurerm_key_vault.security-kv.id
  depends_on   = [azurerm_role_assignment.security-kv-reader]
}

#######################################################
## SECRETS FOR VM
#######################################################

resource "azurerm_key_vault_secret" "vm-secret" {
  name         = "vm-username-secret"
  value        = random_string.sql-admin-username.result
  key_vault_id = azurerm_key_vault.security-kv.id
  depends_on   = [azurerm_role_assignment.security-kv-reader]
}

resource "azurerm_key_vault_secret" "vm-password-secret" {
  name         = "vm-password-secret"
  value        = random_password.security-kv-password.result
  key_vault_id = azurerm_key_vault.security-kv.id
  depends_on   = [azurerm_role_assignment.security-kv-reader]
}

#######################################################
## ROLE ASSIGNMENTS FOR KEY VAULT
#######################################################

resource "azurerm_role_assignment" "security-kv-reader" {
  scope                = azurerm_key_vault.security-kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
  depends_on           = [azurerm_key_vault.security-kv]
}