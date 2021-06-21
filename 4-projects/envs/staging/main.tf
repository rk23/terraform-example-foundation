data "terraform_remote_state" "org" {
  backend = "gcs"
  config = {
    bucket = "bkt-kvi-gcp-foundation-tfstate"
    prefix = "terraform/org/state"
  }
}

locals {
  folders = data.terraform_remote_state.org.outputs.folders
}

data "google_active_folder" "env" {
  display_name = "fldr-${var.environment}"
  parent       = var.parent_folder != "" ? "folders/${var.parent_folder}" : local.folders.engineering
}
