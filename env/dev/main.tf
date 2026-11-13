data "azurerm_client_config" "current" {

}


module "network" {
  source = "../../modules/networking"

  location             = var.location
  address_space        = var.address_space
  subnet_prefixes      = var.subnet_prefixes
  network-watcher-name = var.network-watcher-name
  network-watcher-rg   = var.network-watcher-rg
}


module "database" {
  source = "../../modules/database"

  location = var.location
}

module "monitoring" {
  source = "../../modules/monitoring"

  location = var.location
}

module "security" {
  source = "../../modules/security"

  location = var.location
}

module "identity" {
  source = "../../modules/identity"

  location = var.location
}