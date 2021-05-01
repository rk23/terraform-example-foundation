locals {
  billing_account            = data.terraform_remote_state.bootstrap.outputs.billing_account
  common_folder              = data.terraform_remote_state.bootstrap.outputs.common_folder
  default_region             = data.terraform_remote_state.bootstrap.outputs.default_region
  domain                     = data.terraform_remote_state.bootstrap.outputs.domain
  org_id                     = data.terraform_remote_state.bootstrap.outputs.org_id
  org_basename               = data.terraform_remote_state.bootstrap.outputs.org_basename
  org_shortname              = data.terraform_remote_state.bootstrap.outputs.org_shortname
  terraform_service_account  = data.terraform_remote_state.bootstrap.outputs.terraform_sa_email
  terraform_state_project_id = data.terraform_remote_state.bootstrap.outputs.terraform_state_project_id
}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"
  config = {
    bucket = "bkt-kvi-gcp-foundation-tfstate"
    prefix = "terraform/bootstrap/state"
  }
}