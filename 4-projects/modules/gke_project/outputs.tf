output "gke_project_id" {
  description = "GKE project id."
  value       = module.gke_project.project_id
}

output "gke_project_number" {
  description = "Project sample project number"
  value       = module.gke_project.project_number
}

output "enabled_apis" {
  description = "VPC Service Control services"
  value       = module.gke_project.enabled_apis
}

output "tfstate_bucket" {
  description = "Terraform state bucket information"
  value       = module.gke_project.tfstate_bucket
}
