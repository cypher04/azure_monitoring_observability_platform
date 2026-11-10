data "gitlab_project" "project" {
  path_with_namespace = "${var.gitlab_namespace}/${var.gitlab_project_name}"
}



// gitlab project

resource "gitlab_project_environment" "default_branch" {
  project             = data.gitlab_project.project.id
  name                = "${var.gitlab_default_branch}-${random_string.random_suffix.result}"
  external_url        = "${var.gitlab_base_url}/${var.gitlab_namespace}/${var.gitlab_project_name}/-/environments/${var.gitlab_default_branch}"
  stop_before_destroy = true
  auto_stop_setting   = "always"
}

// gitlab branch protection

resource "gitlab_branch_protection" "default_branch" {
  project = data.gitlab_project.project.id
  branch  = var.gitlab_default_branch
  allowed_to_push = [{
    access_level = "maintainer"
  }]
  allowed_to_merge = [{
    access_level = "developer"
  }]
}

resource "random_string" "random_suffix" {
  length  = 5
  special = false
  upper   = false
}