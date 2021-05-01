locals {
    default_activate_apis = ["cloudasset.googleapis.com"]
    activate_apis = distinct(concat(var.activate_apis, local.default_activate_apis))
    terraform_state_bucket_name = "bkt-${var.org_shortname}-${var.environment_code}-${var.project_name}-tfstate"
    vpc_type = var.enable_shared_vpc_host_project ? "host" : (var.svpc_host_project_id != "" ? "service" : "standalone")

    # If the group already contains a domain, do not append one
    group_permissions = { for group, role in var.group_permissions :
        length(regexall(".+@.+\\..+", group)) == 0
        ? "group:${group}@${var.domain}"
        : "group:${group}"
    => role } 

    group_ids = keys(local.group_permissions)

    labels = {
        env = var.environment
        team = var.team_name
    }
}

module "project" {
    source = "terraform-google-modules/project-factory/google"
    version = "~> 10"

    random_project_id = true
    name = "prj-${var.environment_code}-${var.project_name}"

    activate_api_identities = var.activate_api_identities
    activate_apis = local.activate_apis
    auto_create_network = var.auto_create_network
    billing_account = var.billing_account
    budget_alert_pubsub_topic = var.budget_alert_pubsub_topic
    budget_alert_spent_percents = var.budget_alert_spent_percents
    budget_amount = var.budget_amount
    budget_monitoring_notification_channels = var.budget_monitoring_notification_channels
    credentials_path = var.credentials_path
    default_service_account = var.default_service_account
    disable_services_on_destroy = var.disable_services_on_destroy
    domain = var.domain
    enable_shared_vpc_host_project = var.enable_shared_vpc_host_project
    folder_id = var.folder_id
    impersonate_service_account = var.impersonate_service_account
    lien = var.lien
    org_id = var.org_id
    sa_role = var.sa_role
    svpc_host_project_id = var.svpc_host_project_id
    shared_vpc_subnets = var.shared_vpc_subnets
    usage_bucket_name = var.usage_bucket_name
    usage_bucket_prefix = var.usage_bucket_prefix
    vpc_service_control_attach_enabled = var.vpc_service_control_attach_enabled
    vpc_service_control_perimeter_name = var.vpc_service_control_perimeter_name

    labels = merge(var.additional_labels, local.labels, {
        vpc-type = local.vpc_type
        project-type = var.project_type
    })
}

module "tfstate_bucket" {
    source = "terraform-google-modules/cloud-storage/google"
    version = "~> 1.7"

    admins = concat(["serviceAccount:${var.terraform_service_account}"], local.group_ids)
    names = [local.terraform_state_bucket_name]
    prefix = ""
    set_admin_roles = true
    storage_class = "STANDARD"

    location = var.bucket_location
    project_id = var.terraform_state_project_id

    labels = merge(var.additional_labels, local.labels)

    versioning = {
        (local.terraform_state_bucket_name) = true
    }
}

resource "google_project_iam_member" "gsuite_group_role" {
    for_each = local.group_permissions

    member = each.key
    project = module.project.project_id
    role = each.value
}

resource "google_service_account_iam_member" "service_account_grant_to_group" {
    for_each = local.group_permissions

    member = each.key
    role = "roles/iam.serviceAccountUser"

    service_account_id = "projects/${module.project.project_id}/serviceAccounts/${module.project.service_account_email}"
}