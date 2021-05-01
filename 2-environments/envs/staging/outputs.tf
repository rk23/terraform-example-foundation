output "env_folder" {
  description = "Environment folder created under parent."
  value       = module.env.env_folder
}

output "observability_project_id" {
  description = "Project for observability infra."
  value       = module.env.observability_project_id
}

output "vpc_host_project_id" {
  description = "Project for VPC Host."
  value       = module.env.vpc_host_project_id
}

output "env_secrets_project_id" {
  description = "Project for environment related secrets."
  value       = module.env.env_secrets_project_id
}
