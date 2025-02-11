/******************************************
  Project for monitoring workspaces
*****************************************/

module "observability_project" {
  source = "../../../modules/project_factory"

  project_name_suffix = "observability"
  project_type = "infra"
  team_name    = "alpha"

  group_role_bindings = {
    "gcp-organization-admins" = ["roles/owner"]
  }

  activate_apis = [
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "billingbudgets.googleapis.com",
  ]

  billing_account             = var.billing_account
  budget_alert_pubsub_topic   = var.observability_project_alert_pubsub_topic
  budget_alert_spent_percents = var.observability_project_alert_spent_percents
  budget_amount               = var.observability_project_budget_amount
  domain                      = var.domain
  environment                 = var.environment
  environment_code            = var.environment_code
  folder_id                   = google_folder.env.id
  org_id                      = var.org_id
  org_shortname               = var.org_shortname
  terraform_service_account   = var.terraform_service_account
  terraform_state_project_id  = var.terraform_state_project_id
}
