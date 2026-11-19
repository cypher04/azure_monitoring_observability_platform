data "azurerm_client_config" "current" {

}


module "compute" {
  source = "../../modules/compute"

  location                   = var.location
  vm_username                = module.security.vm_username
  vm_password                = module.security.vm_password
  lb_backend_address_pool_id = module.network.lb_backend_address_pool_id
  subnet_ids                 = module.network.subnet_ids
}

module "network" {
  source = "../../modules/networking"

  location                     = var.location
  address_space                = var.address_space
  subnet_prefixes              = var.subnet_prefixes
  network-watcher-name         = var.network-watcher-name
  network-watcher-rg           = var.network-watcher-rg
  log_storage_account_id       = module.database.log_storage_account_id
  log_analytics_workspace_id   = module.monitoring.log_analytics_workspace_id
  log_analytics_workspace_guid = module.monitoring.log_analytics_workspace_guid
}


module "database" {
  source = "../../modules/database"

  location           = var.location
  sql_admin_username = module.security.sql_admin_username
  sql_admin_password = module.security.sql_admin_password
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