locals {
  group_role_bindings = merge(var.additional_group_role_bindings,
    { for group in var.project_admins : group => [
      "roles/compute.admin",
      "roles/container.admin",
      "roles/gkehub.admin",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountKeyAdmin",
      "roles/iam.serviceAccountUser",
      "roles/iap.tunnelResourceAccessor",
      "roles/meshconfig.admin",
      "roles/monitoring.admin",
      "roles/privateca.admin",
      "roles/resourcemanager.projectIamAdmin",
      "roles/securitycenter.adminEditor",
      "roles/servicemanagement.admin",
      "roles/serviceusage.serviceUsageAdmin",
    ] }
  )
}

module "gke_project" {
  source = "../../../modules/project_factory"

  project_name_suffix = "gke"
  project_type        = "gke"

  activate_apis = [
    "container.googleapis.com",
    "logging.googleapis.com",
    "billingbudgets.googleapis.com",
    "servicenetworking.googleapis.com",
    "meshca.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "gkehub.googleapis.com",
    "gkeconnect.googleapis.com",
    "meshconfig.googleapis.com",
    "meshtelemetry.googleapis.com",
    "cloudtrace.googleapis.com",
    "anthos.googleapis.com",
  ]

  billing_account                    = var.billing_account
  budget_amount                      = var.budget_amount
  domain                             = var.domain
  environment                        = var.environment_code
  environment_code                   = var.environment_code
  folder_id                          = var.folder_id
  org_shortname                      = var.org_shortname
  org_id                             = var.org_id
  group_role_bindings                = local.group_role_bindings
  team_name                          = var.team_name
  terraform_service_account          = var.terraform_service_account
  terraform_state_project_id         = var.terraform_state_project_id
  vpc_service_control_attach_enabled = var.vpc_service_control_attach_enabled
  vpc_service_control_perimeter_name = var.vpc_service_control_perimeter_name

  shared_vpc_subnets   = data.google_compute_network.shared_vpc.subnetworks_self_links
  svpc_host_project_id = data.google_compute_network.shared_vpc.project
}

data "terraform_remote_state" "env" {
  backend = "gcs"
  config = {
    bucket = "bkt-kvi-gcp-foundation-tfstate"
    prefix = "terraform/environments/staging"
  }
}

resource "google_project_organization_policy" "allow_shared_vpc_subnets" {
  project    = module.gke_project.project_id
  constraint = "constraints/compute.restrictSharedVpcSubnetworks"

  list_policy {
    allow {
      values = ["under:projects/${data.terraform_remote_state.env.outputs.vpc_host_project_id}"]
    }
  }
}

resource "google_project_organization_policy" "allow_loadbalancers" {
  project    = module.gke_project.project_id
  constraint = "constraints/compute.restrictLoadBalancerCreationForTypes"

  list_policy {
    allow {
      values = [
        "EXTERNAL_HTTP_HTTPS",
        "EXTERNAL_NETWORK_TCP_UDP",
        "EXTERNAL_SSL_PROXY",
        "INTERNAL_HTTP_HTTPS",
        "INTERNAL_TCP_UDP",
      ]
    }
  }
}

resource "google_project_organization_policy" "allow_internal_ip_forwarding" {
  project    = module.gke_project.project_id
  constraint = "constraints/compute.restrictProtocolForwardingCreationForTypes"

  list_policy {
    allow {
      values = [
        "INTERNAL",
      ]
    }
  }
}

resource "google_project_iam_member" "gke_firewall_role" {
  project = data.terraform_remote_state.env.outputs.vpc_host_project_id
  role    = data.terraform_remote_state.org.outputs.gke_service_agent_firewall_role
  member  = format("serviceAccount:service-%s@container-engine-robot.iam.gserviceaccount.com", module.gke_project.project_number)
}

