locals {
    # service_project_owner_role = var.compute_enabled ? data.terraform_remote_state.org.outputs.service_project_owner_compute_role : data.terraform_remote_state.org.outputs.service_project_owner_role
    service_project_owner_role = ""
    service_project_owners = ["gcp-organization-admins@karavi.cloud"]

    service_project_owner_group_role_bindings = { for group in local.service_project_owners : group => 
      concat(lookup(var.additional_group_role_bindings, group, []), [])
    }
    group_role_bindings = merge(var.additional_group_role_bindings, local.service_project_owner_group_role_bindings)
}

module "service_project" {
  source = "../../../modules/project_factory"

  project_type = "service"
  activate_apis = distinct(concat(var.activate_apis, [
    "billingbudgets.googleapis.com",
    "datamigration.googleapis.com",
    "iam.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "redis.googleapis.com",
  ]))

  billing_account                    = var.billing_account
  budget_amount                      = var.budget_amount
  domain                             = var.domain
  environment                        = var.environment_code
  environment_code                   = var.environment_code
  folder_id                          = var.folder_id
  group_role_bindings                = local.group_role_bindings
  org_shortname                      = var.org_shortname
  org_id                             = var.org_id
  project_name_suffix                = var.project_name_suffix
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
  count = var.compute_enabled ? 1 : 0

  project    = module.service_project.project_id
  constraint = "constraints/compute.restrictSharedVpcSubnetworks"

  list_policy {
    allow {
      values = ["under:projects/${data.terraform_remote_state.env.outputs.vpc_host_project_id}"]
    }
  }
}

resource "google_project_organization_policy" "allow_vm_external_ip_access" {
  count = var.vm_external_ip_access ? 1 : 0

  project    = module.service_project.project_id
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "require_shielded_vms" {
  count = var.compute_enabled ? 1 : 0

  project    = module.service_project.project_id
  constraint = "constraints/compute.requireShieldedVm"

  boolean_policy {
    enforced = false
  }
}
