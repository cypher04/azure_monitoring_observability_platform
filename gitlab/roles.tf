#######################################################
## ROLES
#######################################################
resource "azurerm_role_assignment" "gitlab_contributor" {
  principal_id         = azuread_service_principal.gitlab.object_id
  role_definition_name = "Contributor"
  scope                = "/subscriptions/${var.subscription_id}"
}

resource "azurerm_role_assignment" "gitlab_reader" {
  principal_id         = azuread_service_principal.gitlab.object_id
  role_definition_name = "Role Based Access Control Administrator"
  scope                = "/subscriptions/${var.subscription_id}"
}

#######################################################
## role assignment for sp to access state storage
resource "azurerm_role_assignment" "gitlab_storage_account" {
  principal_id         = azuread_service_principal.gitlab.object_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/azmonitoring-state-dev/providers/Microsoft.Storage/storageAccounts/azmonitoringstatedev"
}
#######################################################
