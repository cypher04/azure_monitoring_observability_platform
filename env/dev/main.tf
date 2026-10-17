data "azurerm_client_config" "current" {

}


module "network" {
  source = "../../modules/networking"

  location        = var.location
  address_space   = var.address_space
  subnet_prefixes = var.subnet_prefixes
}