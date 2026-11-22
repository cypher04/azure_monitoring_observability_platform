output "vm_id" {
  value = azurerm_windows_virtual_machine.windows-vm.id
}

output "nic_id" {
  value = azurerm_network_interface.windows-nic.id
}

output "vm_principal_id" {
  value = azurerm_windows_virtual_machine.windows-vm.identity[0].principal_id
}