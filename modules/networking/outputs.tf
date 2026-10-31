output "hub_vnet_id" {
  value = azurerm_virtual_network.hub-vnet.id
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke-vnet.id
}

output "subnet_ids" {
  value = [
    azurerm_subnet.hub-subnet.id,
    azurerm_subnet.spoke-subnet.id
  ]
}