output "hub_vnet_id" {
  value = azurerm_virtual_network.hub-vnet.id
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke-vnet.id
}

output "subnet_ids" {
  value = [
    azurerm_subnet.hub-subnet.id,
    azurerm_subnet.spoke-subnet.id,
    azurerm_subnet.aks-subnet.id,
    azurerm_subnet.app-gtw-subnet.id
  ]
}

output "network_watcher_id" {
  value = data.azurerm_network_watcher.network-watcher.id
}