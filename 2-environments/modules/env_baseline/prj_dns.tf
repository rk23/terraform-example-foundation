/******************************************
  Project for Environment DNS
*****************************************/

module "env_dns" {
  source = "../../../modules/project_factory"

  project_name = "dns"
  project_type = "infra"
  team_name    = "alpha"

  group_permissions = {
    "gcp-organization-admins" = "roles/owner"
  }

  activate_apis = [
    "dns.googleapis.com",
  ]

  billing_account             = var.billing_account
  budget_alert_pubsub_topic   = var.dns_project_alert_pubsub_topic
  budget_alert_spent_percents = var.dns_project_alert_spent_percents
  budget_amount               = var.dns_project_budget_amount
  domain                      = var.domain
  environment                 = var.environment
  environment_code            = var.environment_code
  folder_id                   = google_folder.env.id
  org_id                      = var.org_id
  org_shortname               = var.org_shortname
  terraform_service_account   = var.terraform_service_account
  terraform_state_project_id  = var.terraform_state_project_id
}

resource "google_project_organization_policy" "dns_service" {
  project    = module.env_dns.project_id
  constraint = "constraints/serviceuser.services"

  list_policy {
    deny {
      values = [
        "compute.googleapis.com",
        "deploymentmanager.googleapis.com",
        "doubleclicksearch.googleapis.com",
        "replicapool.googleapis.com",
        "replicapoolupdater.googleapis.com",
        "resourceviews.googleapis.com",
      ]
    }
  }
}
