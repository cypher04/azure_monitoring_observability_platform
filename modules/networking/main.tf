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

########################################################
## spoke Virtual Network
########################################################
resource "azurerm_virtual_network" "spoke-vnet" {
  name                = "spoke-vnet"
  address_space       = [var.address_space[1]]
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name
}

resource "azurerm_subnet" "spoke-subnet" {
  name                 = "spoke-subnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet.name
  address_prefixes     = [var.subnet_prefixes["spoke-subnet"]]
}

////////////////////////////////////////////////////////
## Virtual Network Peering
////////////////////////////////////////////////////////
resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                         = "hub-to-spoke"
  resource_group_name          = azurerm_resource_group.networking.name
  virtual_network_name         = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke-vnet.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                         = "spoke-to-hub"
  resource_group_name          = azurerm_resource_group.networking.name
  virtual_network_name         = azurerm_virtual_network.spoke-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub-vnet.id
  allow_virtual_network_access = true
}
