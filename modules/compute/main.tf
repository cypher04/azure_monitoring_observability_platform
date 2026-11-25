resource "azurerm_resource_group" "compute-rg" {
  name     = "compute-rg"
  location = var.location
}

#######################################################
## windows virtual machine
#######################################################

resource "azurerm_network_interface" "windows-nic" {
  name                = "windows-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.compute-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_ids["spoke-subnet"]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windows-vm" {
  name                = "windows-vm"
  resource_group_name = azurerm_resource_group.compute-rg.name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = var.vm_username
  admin_password      = var.vm_password
  network_interface_ids = [
    azurerm_network_interface.windows-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {

  }

  identity {
    type = "SystemAssigned"
  }
}

#######################################################
## ATTACH NIC TO BACKEND POOL ADDRESS OF LB
#######################################################

resource "azurerm_network_interface_backend_address_pool_association" "nic-backend-association" {
  network_interface_id    = azurerm_network_interface.windows-nic.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.lb_backend_address_pool_id
}

#######################################################
## virtual machine extension
#######################################################
resource "azurerm_virtual_machine_extension" "windows-vm-extension" {
  name                 = "windows-vm-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.windows-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    { 
      "commandToExecute": "powershell -Command Install-WindowsFeature -Name Web-Server"
    }
  SETTINGS
}