resource "azurerm_resource_group" "db-rg" {
  name     = "db-resources"
  location = var.location
}

#######################################################
## Storage Account
#######################################################
resource "azurerm_storage_account" "log-storage" {
  name                            = "dbstorageaccount${random_string.storage_suffix.result}"
  resource_group_name             = azurerm_resource_group.db-rg.name
  location                        = azurerm_resource_group.db-rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "log-container" {
  name                  = "log-container"
  storage_account_id    = azurerm_storage_account.log-storage.id
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "log-storage-policy" {
  storage_account_id = azurerm_storage_account.log-storage.id

  rule {
    name    = "log-storage-rule"
    enabled = true

    filters {
      blob_types = ["blockBlob"]
    }

    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 365
      }
    }
  }
}

resource "random_string" "storage_suffix" {
  length  = 4
  special = false
  upper   = false
}

#######################################################
## azure sql database
#######################################################

resource "azurerm_mssql_server" "sql-server" {
  name                         = "sql-server-${random_string.storage_suffix.result}"
  resource_group_name          = azurerm_resource_group.db-rg.name
  location                     = azurerm_resource_group.db-rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}


resource "azurerm_mssql_database" "sql-database" {
  name         = "sql-database-${random_string.storage_suffix.result}"
  sku_name     = "S0"
  server_id    = azurerm_mssql_server.sql-server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  enclave_type = "VBS"
}
