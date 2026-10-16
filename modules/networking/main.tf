resource "azurerm_resource_group" "networking" {
  name     = "networking-rg"
  location = var.location
}


########################################################
## hub Virtual Network
########################################################
resource "azurerm_virtual_network" "hub-vnet" {
  name                = "hub-vnet"
  address_space       = [var.address_space[0]]
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name
}

resource "azurerm_subnet" "hub-subnet" {
  name                 = "hub-subnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = [var.subnet_prefixes["hub-subnet"]]
}