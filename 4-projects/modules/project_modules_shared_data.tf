data "google_projects" "projects" {
  filter = "parent.id:${split("/", var.folder_id)[1]} name:prj-${var.environment_code}-vpc-host* lifecycleState=ACTIVE"
}

data "google_compute_network" "shared_vpc" {
  name    = "vpc-${var.environment_code}-shared"
  project = data.google_projects.projects.projects[0].project_id
}

data "terraform_remote_state" "org" {
  backend = "gcs"
  config = {
    bucket = "bkt-kvi-gcp-foundation-tfstate"
    prefix = "terraform/org/state"
  }
}
