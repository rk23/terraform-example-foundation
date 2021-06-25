variable "environment" {
  description = "The environment"
  type        = string
}

variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization (ex. d)."
}

variable "gke_service_account_groups" {
  description = "IAM groups to add servcie accounts to"
  type        = list(string)
}

variable "cluster_admin_groups" {
  description = "The RBAC groups that will get cluster admin permissions"
  type        = list(string)
}