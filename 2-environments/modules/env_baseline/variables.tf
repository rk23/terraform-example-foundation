variable "environment" {
  description = "The environment"
  type        = string
}

variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization (ex. d)."
}

variable "parent_id" {
  description = "The parent folder or org for environments"
  type        = string
}

variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "org_shortname" {
  description = "Shortname of org"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  type        = string
}

variable "terraform_service_account" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}

variable "terraform_state_project_id" {
  description = "Project used to store the terraform state buckets."
  type        = string
}

variable "monitoring_workspace_users" {
  description = "Google Workspace or Cloud Identity group that have access to Monitoring Workspaces."
  type        = string
  default     = ""
}

variable "base_network_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded for the base networks project"
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "base_network_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the base networks project"
  type        = string
  default     = null
}

variable "base_network_project_budget_amount" {
  description = "The amount to use as the budget for the base networks project"
  type        = number
  default     = 100
}

variable "restricted_network_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded for the restricted networks project."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "restricted_network_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the restricted networks project"
  type        = string
  default     = null
}

variable "restricted_network_project_budget_amount" {
  description = "The amount to use as the budget for the restricted networks project."
  type        = number
  default     = 100
}

variable "monitoring_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded for the monitoring project."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "monitoring_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the monitoring project."
  type        = string
  default     = null
}

variable "monitoring_project_budget_amount" {
  description = "The amount to use as the budget for the monitoring project."
  type        = number
  default     = 100
}

variable "secret_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded for the secrets project."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "secret_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the secrets project."
  type        = string
  default     = null
}

variable "secret_project_budget_amount" {
  description = "The amount to use as the budget for the secrets project."
  type        = number
  default     = 100
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

variable "domain" {
  description = "Org domain"
  type        = string
}

variable "dns_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}"
  type        = string
  default     = null
}

variable "dns_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeding."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "dns_project_budget_amount" {
  description = "The amount to use as the budget."
  type        = number
  default     = 100
}

variable "observability_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}"
  type        = string
  default     = null
}

variable "observability_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeding."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "observability_project_budget_amount" {
  description = "The amount to use as the budget."
  type        = number
  default     = 100
}

variable "vpc_host_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}"
  type        = string
  default     = null
}

variable "vpc_host_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeding."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "vpc_host_project_budget_amount" {
  description = "The amount to use as the budget."
  type        = number
  default     = 100
}