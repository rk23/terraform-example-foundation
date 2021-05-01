data "terraform_remote_state" "shared" {
  backend = "gcs"
  config = {
    bucket = "bkt-kvi-gcp-foundation-tfstate"
    prefix = "terraform/org/state"
  }
}

locals {
  folders = data.terraform_remote_state.shared.outputs.folders
}

module "env" {
  source = "../../modules/env_baseline"

  billing_account            = local.billing_account
  domain                     = local.domain
  environment                = var.environment
  environment_code           = var.environment_code
  parent_id                  = local.folders.engineering
  org_id                     = local.org_id
  org_shortname              = local.org_shortname
  terraform_service_account  = local.terraform_service_account
  terraform_state_project_id = local.terraform_state_project_id
}
