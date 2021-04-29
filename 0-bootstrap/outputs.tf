output "seed_project_id" {
  description = "Project where service accounts and core APIs will be enabled."
  value       = module.seed_bootstrap.seed_project_id
}

output "terraform_service_account" {
  description = "Email for privileged service account for Terraform."
  value       = module.seed_bootstrap.terraform_sa_email
}

output "terraform_sa_name" {
  description = "Fully qualified name for privileged service account for Terraform."
  value       = module.seed_bootstrap.terraform_sa_name
}

output "gcs_bucket_tfstate" {
  description = "Bucket used for storing terraform state for foundations pipelines in seed project."
  value       = module.seed_bootstrap.gcs_bucket_tfstate
}

output "gcp_foundation_tfstate" {
  description = "Bucket used for storing terraform state of gcp-foundation"
  value = local.gcp_foundation_tfstate_bucket_name
}

output "org_settings_tfstate" {
  description = "Bucket used for storing terraform state of org-settings"
  value = local.gcp_foundation_tfstate_bucket_name
}

output "org_id" {
  description = "ID for the org"
  value = var.org_id
}

output "domain" {
  description = "Org domain that has been bootstrapped"
  value = var.domain
}

output "org_basename" {
  description = "Org domain without extension"
  value = local.org_basename
}

output "org_shortname" {
  description = "A short name to represent org"
  value = var.org_shortname
}

output "default_region" {
  description = "Default region for the org"
  value = var.default_region
}

output "group_org_admins" {
  description = "Gsuite groups that have admin rights to org"
  value = var.group_org_admins
}

output "group_billing_admins" {
  description = "Gsuite group that has billing admin access"
  value = var.group_billing_admins
} 

output "billing_account" {
  description = "Billing account associated with the org"
  value = var.billing_account
}

output "terraform_sa_email" {
  description = "Email for privileged service account for Terraform"
  value = module.seed_bootstrap.terraform_sa_email
}

output "common_folder" {
  description = "ID of the common folder" 
  value = google_folder.common
}

output "terraform_state_project_id" {
  description = "Project ID of the terraform state project" 
  value = module.prj_terraform_state.project_id
}
