/*************************************************
  Bootstrap GCP Organization.
*************************************************/
locals {
  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  org_admins_org_iam_permissions = var.org_policy_admin_role == true ? [
    "roles/orgpolicy.policyAdmin", "roles/resourcemanager.organizationAdmin", "roles/billing.user"
  ] : ["roles/resourcemanager.organizationAdmin", "roles/billing.user"]

  org_basename = split(".", var.domain)[0]
  gcp_foundation_tfstate_bucket_name = "bkt-${var.org_shortname}-gcp-foundation-tfstate"
  org_settings_tfstate_bucket_name = "bkt-${var.org_shortname}-org-settings-tfstate"
}

resource "random_id" "suffix" {
  byte_length = 2
}
