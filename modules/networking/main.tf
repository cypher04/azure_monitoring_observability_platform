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
  depends_on                   = [azurerm_virtual_network_peering.hub-to-spoke]
}

########################################################
## Network Security Groups
########################################################
resource "azurerm_network_security_group" "hub-nsg" {
  name                = "hub-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name


  security_rule {
    name                       = "allow-traffic-from-spoke"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.subnet_prefixes["spoke-subnet"]
    destination_address_prefix = var.subnet_prefixes["hub-subnet"]
  }

  security_rule {
    name                       = "allow-traffic-to-spoke"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.subnet_prefixes["hub-subnet"]
    destination_address_prefix = var.subnet_prefixes["spoke-subnet"]
  }

  security_rule {
    name                       = "deny-internal-traffic"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "deny-internal-traffic-outbound"
    priority                   = 1004
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }


}


resource "azurerm_network_security_group" "spoke-nsg" {
  name                = "spoke-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name

  security_rule {
    name                       = "allow-traffic-from-hub"
    priority                   = 2001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.subnet_prefixes["hub-subnet"]
    destination_address_prefix = var.subnet_prefixes["spoke-subnet"]
  }
  security_rule {
    name                       = "allow-traffic-to-hub"
    priority                   = 2002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.subnet_prefixes["spoke-subnet"]
    destination_address_prefix = var.subnet_prefixes["hub-subnet"]
  }

  security_rule {
    name                       = "deny-internal-traffic"
    priority                   = 2003
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "deny-internal-traffic-outbound"
    priority                   = 2004
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}

#######################################################
## Security groups association for hub and spoke subnets
#######################################################
resource "azurerm_subnet_network_security_group_association" "hub-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.hub-subnet.id
  network_security_group_id = azurerm_network_security_group.hub-nsg.id
}

resource "azurerm_subnet_network_security_group_association" "spoke-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.spoke-subnet.id
  network_security_group_id = azurerm_network_security_group.spoke-nsg.id
}


#######################################################
## nat gateway
#######################################################
resource "azurerm_nat_gateway" "hub-nat-gateway" {
  name                    = "hub-nat-gateway"
  location                = var.location
  resource_group_name     = azurerm_resource_group.networking.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_public_ip" "hub-nat-gateway-pip" {
  name                = "hub-nat-gateway-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name
  allocation_method   = "Static"
}

resource "azurerm_nat_gateway_public_ip_association" "hub-nat-gateway-pip-association" {
  nat_gateway_id       = azurerm_nat_gateway.hub-nat-gateway.id
  public_ip_address_id = azurerm_public_ip.hub-nat-gateway-pip.id
}

resource "azurerm_subnet_nat_gateway_association" "hub-subnet-nat-assoc" {
  subnet_id      = azurerm_subnet.hub-subnet.id
  nat_gateway_id = azurerm_nat_gateway.hub-nat-gateway.id
}