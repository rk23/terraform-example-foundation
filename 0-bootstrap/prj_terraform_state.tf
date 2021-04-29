module "prj_terraform_state" {
    source = "terraform-google-modules/project-factory/google"
    version = "~> 10"

    activate_apis = [
        "storage-api.googleapis.com"
    ]

    auto_create_network = false
    billing_account = var.billing_account
    default_service_account = "delete"
    folder_id = google_folder.common.id
    lien = true
    org_id = var.org_id
    name = "prj-c-terraform-state"
    random_project_id = true
}

# Allow the seed terraform service account to admin terraform state buckets
resource "google_project_iam_member" "seed_storage_admin" {
    project = module.prj_terraform_state.project_id
    role = "roles/storage.admin"
    member = "serviceAccount:${module.seed_bootstrap.terraform_sa_email}"
}

module "gcp_foundation_tfstate_bucket" {
    source = "terraform-google-modules/cloud-storage/google"
    version = "~> 1.7"

    admins = ["serviceAccount:${module.seed_bootstrap.terraform_sa_email}", "group:${var.group_org_admins}"]
    names = [local.gcp_foundation_tfstate_bucket_name]
    prefix = ""
    set_admin_roles = true
    storage_class = "STANDARD"

    location = var.bucket_location
    project_id = module.prj_terraform_state.project_id

    versioning = {
        (local.gcp_foundation_tfstate_bucket_name) = true
    }
}

module "org_settings_tfstate_bucket" {
    source = "terraform-google-modules/cloud-storage/google"
    version = "~> 1.7"

    admins = ["serviceAccount:${module.seed_bootstrap.terraform_sa_email}", "group:${var.group_org_admins}"]
    names = [local.org_settings_tfstate_bucket_name]
    prefix = ""
    set_admin_roles = true
    storage_class = "STANDARD"
    location = var.bucket_location
    project_id = module.prj_terraform_state.project_id

    versioning = {
        (local.gcp_foundation_tfstate_bucket_name) = true
    }
}
