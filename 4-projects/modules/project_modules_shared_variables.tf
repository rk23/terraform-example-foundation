/**************************************************************
 Required Variables
**************************************************************/

variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}

variable "domain" {
  type        = string
  description = "Domain of the organziation"
}

variable "environment" {
  description = "The environment"
  type        = string
}

variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization (ex. d)."
}

variable "folder_id" {
  description = "Folder id where the project will be created."
  type        = string
}

variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "org_shortname" {
  description = "Shortname of org"
  type        = string
}

variable "terraform_service_account" {
  description = "Terraform service account used to apply the terraform"
  type        = string
}

variable "terraform_state_project_id" {
  description = "Project used to store the terraform state buckets"
  type        = string
}

/**************************************************************
 Optional Variables
**************************************************************/

variable "additional_group_role_bindings" {
  description = "A map of additional groups to bind to roles for this project. group -> list(roles)"
  type        = map(list(string))
  default     = {}
}

variable "budget_amount" {
  description = "The amount to use as the budget"
  type        = number
  default     = 20
}

variable "team_name" {
  description = "The name of the team who owns this project"
  type        = string
  default     = "alpha"
}

variable "vpc_service_control_attach_enabled" {
  description = "Whether the project will be attached to a VPC Service Control Perimeter."
  type        = string
  default     = false
}

variable "vpc_service_control_perimeter_name" {
  description = "The name of a VPC Service Control Perimeter to add the created project to."
  type        = string
  default     = null
}
