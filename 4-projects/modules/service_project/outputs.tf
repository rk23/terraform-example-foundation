output "project_id" {
  description = "Project id."
  value       = module.service_project.project_id
}

output "project_number" {
  description = "Project number"
  value       = module.service_project.project_number
}

output "enabled_apis" {
  description = "VPC Service Control services."
  value       = module.service_project.enabled_apis
}

output "tfstate_bucket" {
  description = "Terraform state bucket information"
  value       = module.service_project.tfstate_bucket
}