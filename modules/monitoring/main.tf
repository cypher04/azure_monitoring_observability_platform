resource "azurerm_resource_group" "log-rg" {
  name     = "example-resources"
  location = var.location
}



#######################################################
## log analytics workspace
#######################################################
resource "azurerm_log_analytics_workspace" "log-workspace" {
  name                = "log-workspace"
  location            = azurerm_resource_group.log-rg.location
  resource_group_name = azurerm_resource_group.log-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

