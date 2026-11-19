output "hub_vnet_id" {
  value = azurerm_virtual_network.hub-vnet.id
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke-vnet.id
}

output "subnet_ids" {
  value = {
    "hub-subnet"     = azurerm_subnet.hub-subnet.id,
    "spoke-subnet"   = azurerm_subnet.spoke-subnet.id,
    "aks-subnet"     = azurerm_subnet.aks-subnet.id,
    "app-gtw-subnet" = azurerm_subnet.app-gtw-subnet.id
  }
}

output "network_watcher_id" {
  value = data.azurerm_network_watcher.network-watcher.id
}

output "zone_ids" {

  value = {
    "log-analytics-private-dns-zone"   = azurerm_private_dns_zone.log-analytics-private-dns-zone.id,
    "key-vault-private-dns-zone"       = azurerm_private_dns_zone.key-vault-private-dns-zone.id,
    "storage-account-private-dns-zone" = azurerm_private_dns_zone.storage-account-private-dns-zone.id
  }
}

output "lb_backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.load-balancer-backend-pool.id
}