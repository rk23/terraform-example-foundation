module "gke_project" {
  source = "../../modules/gke_project"

  budget_amount = 100
  team_name     = "alpha"
  project_admins = [
    "gcp-organization-admins@karavi.cloud",
  ]

  billing_account            = local.billing_account
  domain                     = local.domain
  environment                = var.environment
  environment_code           = var.environment_code
  folder_id                  = data.google_active_folder.env.name
  org_shortname              = local.org_shortname
  org_id                     = local.org_id
  terraform_state_project_id = local.terraform_state_project_id
  terraform_service_account  = local.terraform_service_account
}