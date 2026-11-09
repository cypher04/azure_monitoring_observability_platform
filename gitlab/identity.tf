#######################################################
## App Registration
#######################################################

data "azuread_client_config" "current" {}

resource "azuread_application" "gitlab_app" {
  display_name     = "gitlab"
  sign_in_audience = "AzureADMyOrg"
  owners           = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "gitlab" {
  client_id                    = azuread_application.gitlab_app.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}



#######################################################
## FEDERATED IDENTITY CREDENTIALS
#######################################################

resource "azuread_application_federated_identity_credential" "gitlab" {
  issuer         = var.gitlab_base_url
  subject        = "project_path:${var.gitlab_namespace}/${var.gitlab_project_name}:ref_type:branch:ref:${var.gitlab_default_branch}"
  audiences      = [var.gitlab_base_url]
  application_id = azuread_application.gitlab_app.id
  display_name   = "gitlab-federated-identity"
  description    = "Federated identity for GitLab"

}