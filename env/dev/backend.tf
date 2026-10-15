// Backend configuration for the development environment
terraform {
  backend "azurerm" {
    resource_group_name   = "azmonitoring-state-dev"
    storage_account_name  = "azmonitoringstatedev"
    container_name        = "tfstate"
    key                   = "monitoring.terraform.tfstate"
  }
}