resource "azurerm_resource_group" "db-rg" {
  name     = "db-resources"
  location = var.location
}

#######################################################
## Storage Account
#######################################################
resource "azurerm_storage_account" "log-storage" {
  name                     = "dbstorageaccount"
  resource_group_name      = azurerm_resource_group.db-rg.name
  location                 = azurerm_resource_group.db-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "log-container" {
  name                  = "log-container"
  storage_account_id    = azurerm_storage_account.log-storage.id
  container_access_type = "private"
}


