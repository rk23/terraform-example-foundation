output "project_name" {
  value = module.project.project_name
}

output "project_id" {
  value = module.project.project_id
}

output "project_number" {
  value = module.project.project_number
}

output "domain" {
  value       = module.project.domain
  description = "The organization's domain"
}

output "group_email" {
  value       = module.project.group_email
  description = "The email of the G Suite group with group_name"
}

output "service_account_id" {
  value       = module.project.service_account_id
  description = "The id of the default service account"
}

output "service_account_display_name" {
  value       = module.project.service_account_display_name
  description = "The display name of the default service account"
}

output "service_account_email" {
  value       = module.project.service_account_email
  description = "The email of the default service account"
}

output "service_account_name" {
  value       = module.project.service_account_name
  description = "The fully-qualified name of the default service account"
}

output "service_account_unique_id" {
  value       = module.project.service_account_unique_id
  description = "The unique id of the default service account"
}

output "project_bucket_self_link" {
  value       = module.project.project_bucket_self_link
  description = "Project's bucket selfLink"
}

output "project_bucket_url" {
  value       = module.project.project_bucket_url
  description = "Project's bucket url"
}

output "api_s_account" {
  value       = module.project.api_s_account
  description = "API service account email"
}

output "api_s_account_fmt" {
  value       = module.project.api_s_account_fmt
  description = "API service account email formatted for terraform use"
}

output "enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.project.enabled_apis
}

output "budget_name" {
  value       = module.project.budget_name
  description = "The name of the budget if created"
}

output "tfstate_bucket" {
  value       = module.tfstate_bucket.bucket.name
  description = "The name of the budget if created"
}
