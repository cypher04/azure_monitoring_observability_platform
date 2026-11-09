resource "gitlab_project_variable" "gitlab_token" {
  key       = "AZUREAD_GITLAB_TOKEN"
  value     = var.gitlab_token
  project   = "${var.gitlab_namespace}/${var.gitlab_project_name}"
  protected = true
  masked    = false
}

resource "gitlab_project_variable" "subscription_id" {
  key       = "AZUREAD_SUBSCRIPTION_ID"
  value     = var.subscription_id
  project   = "${var.gitlab_namespace}/${var.gitlab_project_name}"
  protected = true
  masked    = false
}

resource "gitlab_project_variable" "tenant_id" {
  key       = "AZUREAD_TENANT_ID"
  value     = var.tenant_id
  project   = "${var.gitlab_namespace}/${var.gitlab_project_name}"
  protected = true
  masked    = false
}

resource "gitlab_project_variable" "client_id" {
  key       = "AZUREAD_CLIENT_ID"
  value     = azuread_application.gitlab_app.client_id
  project   = "${var.gitlab_namespace}/${var.gitlab_project_name}"
  protected = true
  masked    = false
}