module "org_billing_logs" {
  source = "../../../modules/project_factory"

  project_name_suffix = "billing-logs"
  project_type        = "infra"
  team_name           = "alpha"

  group_role_bindings = {
    "gcp-organization-admins" = ["roles/owner"]
  }

  activate_apis = [
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "billingbudgets.googleapis.com",
  ]

  billing_account             = local.billing_account
  budget_alert_pubsub_topic   = var.dns_hub_project_alert_pubsub_topic
  budget_alert_spent_percents = var.dns_hub_project_alert_spent_percents
  budget_amount               = var.dns_hub_project_budget_amount
  domain                      = local.domain
  environment                 = var.environment
  environment_code            = var.environment_code
  folder_id                   = local.common_folder.id
  org_id                      = local.org_id
  org_shortname               = local.org_shortname
  terraform_service_account   = local.terraform_service_account
  terraform_state_project_id  = local.terraform_state_project_id
}
