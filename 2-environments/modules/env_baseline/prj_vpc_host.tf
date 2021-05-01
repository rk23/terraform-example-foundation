/******************************************
  Project for Shared VPCs
*****************************************/

module "vpc_host_project" {
  source = "../../../modules/project_factory"

  project_name = "vpc-host"
  project_type = "infra"
  team_name    = "alpha"

  group_permissions = {
    "gcp-organization-admins" = "roles/owner"
  }

  activate_apis = [
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "logging.googleapis.com",
    "billingbudgets.googleapis.com",
    "dns.googleapis.com",
  ]

  billing_account             = var.billing_account
  budget_alert_pubsub_topic   = var.vpc_host_project_alert_pubsub_topic
  budget_alert_spent_percents = var.vpc_host_project_alert_spent_percents
  budget_amount               = var.vpc_host_project_budget_amount
  domain                      = var.domain
  environment                 = var.environment
  environment_code            = var.environment_code
  folder_id                   = google_folder.env.id
  org_id                      = var.org_id
  org_shortname               = var.org_shortname
  terraform_service_account   = var.terraform_service_account
  terraform_state_project_id  = var.terraform_state_project_id
}

resource "google_project_organization_policy" "vpc_services_denied" {
  project    = module.vpc_host_project.project_id
  constraint = "constraints/serviceuser.services"

  list_policy {
    deny {
      values = [
        "deploymentmanager.googleapis.com",
        "doubleclicksearch.googleapis.com",
        "replicapool.googleapis.com",
        "replicapoolupdater.googleapis.com",
        "resourceviews.googleapis.com",
      ]
    }
  }
}

resource "google_folder_organization_policy" "allow_shared_vpc" {
    folder = google_folder.env.id
    constraint = "constraints/compute.restrictSharedVpcHostProjects"

    list_policy {
        allow {
            values = [
                "projects/${module.vpc_host_project.project_id}"
            ]
        }
    }
}
