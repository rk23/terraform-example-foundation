variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}

variable "group_org_admins" {
  description = "Google Group for GCP Organization Administrators"
  type        = string
}

variable "group_billing_admins" {
  description = "Google Group for GCP Billing Administrators"
  type        = string
}

variable "default_region" {
  description = "Default region to create resources where applicable."
  type        = string
  default     = "us-central1"
}

variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}

variable "org_project_creators" {
  description = "Additional list of members to have project creator role across the organization. Prefix of group: user: or serviceAccount: is required."
  type        = list(string)
  default     = []
}

variable "org_policy_admin_role" {
  description = "Additional Org Policy Admin role for admin group. You can use this for testing purposes."
  type        = bool
  default     = false
}

variable "project_prefix" {
  description = "Name prefix to use for projects created."
  type        = string
  default     = "prj"
}

variable "folder_prefix" {
  description = "Name prefix to use for folders created."
  type        = string
  default     = "fldr"
}

variable "bucket_prefix" {
  description = "Name prefix to use for state bucket created."
  type        = string
  default     = "bkt"
}

variable "cloud_source_repos" {
  description = "List of Cloud Source Repositories created during bootstrap project build stage for use with Cloud Build."
  type        = list(string)
  default     = ["gcp-org", "gcp-environments", "gcp-networks", "gcp-projects"]
}

variable "org_shortname" {
  description = "Shortname of org"
  type = string
}

variable "domain" {
  type = string
  description = "Domain of the organziation"
}

variable "bucket_location" {
  type = string
  description = "Location of bucket"
}