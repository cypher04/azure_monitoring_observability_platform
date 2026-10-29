resource"azurerm_resource_group" "identity-rg" {
  name     = "identity-rg"
  location = var.location
}


resource "azurerm_user_assigned_identity" "identity" {
  name                = "identity"
  resource_group_name = azurerm_resource_group.identity-rg.name
  location            = var.location
}