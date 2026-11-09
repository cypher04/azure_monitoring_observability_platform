variable "tenant_id" {
  description = "The ID of the Azure tenant."
  type        = string
}

variable "gitlab_token" {
  description = "The personal access token for GitLab."
  type        = string
}

variable "gitlab_default_branch" {
  description = "The default branch of the GitLab repository."
  type        = string
}

variable "gitlab_base_url" {
  description = "The base URL of the GitLab instance."
  type        = string
}

variable "subscription_id" {
  description = "The ID of the Azure subscription."
  type        = string
}

variable "gitlab_namespace" {
  description = "The namespace of the GitLab repository."
  type        = string
}

variable "gitlab_project_name" {
  description = "The name of the GitLab project."
  type        = string
}


