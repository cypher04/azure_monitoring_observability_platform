data "gitlab_project" "project" {
  path_with_namespace = "${var.gitlab_namespace}/${var.gitlab_project_name}"
}



// gitlab project

resource "gitlab_project_environment" "default_branch" {
  project             = data.gitlab_project.project.id
  name                = var.gitlab_default_branch
  stop_before_destroy = true
  auto_stop_setting   = "always"
}

// gitlab branch protection

resource "gitlab_branch_protection" "default_branch" {
  project            = data.gitlab_project.project.id
  branch             = var.gitlab_default_branch
  push_access_level  = "maintainer"
  merge_access_level = "developer"
  #   allowed_to_push = [{
  #     access_level = "maintainer"
  #   }]
  #   allowed_to_merge = [{
  #     access_level = "developer"
  #   }]
}