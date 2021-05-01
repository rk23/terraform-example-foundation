variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  type        = string
}

variable "domain" {
  description = "The domain name (optional)."
  type        = string
}

variable "environment" {
  description = "The environment the single project belongs to."
  type        = string
}

variable "environment_code" {
  description = "A short form of the env."
  type        = string
}

variable "folder_id" {
  description = "The ID of a folder to host this project"
  type        = string
}

variable "group_permissions" {
  description = "A map of groups and roles for this project. If the group name does not end in `@<domain>`, `@<var.domain>` will be suffixed"
  type        = map(string)
}

variable "org_shortname" {
  description = "A short name to represent the GCP organization"
  type        = string
}

variable "org_id" {
  description = "The organization ID."
  type        = string
}

variable "project_name" {
  description = "The name for the project"
  type        = string
}

variable "team_name" {
  description = "The name of the team who owns this project"
  type = string
}

variable "terraform_state_project_id" {
  description = "Project used to store the terraform state buckets."
  type        = string
}


variable "terraform_service_account" {
  description = "Terraform service account used to apply the terraform"
  type        = string
}


###### Optional Variables (alpha-sorted) #########

variable "activate_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default     = []
}

variable "activate_api_identities" {
  description = <<EOF
    The list of service identities (Google Managed service account for the API) to force-create for the project (e.g. in order to grant additional roles).
    APIs in this list will automatically be appended to `activate_apis`.
    Not including the API in this list will follow the default behaviour for identity creation (which is usually when the first resource using the API is created).
    Any roles (e.g. service agent role) must be explicitly listed. See https://cloud.google.com/iam/docs/understanding-roles#service-agent-roles-roles for a list of related roles.
  EOF
  type = list(object({
    api   = string
    roles = list(string)
  }))
  default = []
}

variable "additional_labels" {
  description = "Map of labels for project"
  type = map(string)
  default = {}
}

variable "auto_create_network" {
  description = "Create the default network"
  type        = bool
  default     = false
}

variable "budget_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}`"
  type        = string
  default     = null
}

variable "budget_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded"
  type        = list(number)
  default     = [0.5, 0.7, 1.0]
}

variable "budget_amount" {
  description = "The amount to use for a budget alert"
  type        = number
  default     = null
}

variable "budget_monitoring_notification_channels" {
  description = "A list of monitoring notification channels in the form `[projects/{project_id}/notificationChannels/{channel_id}]`. A maximum of 5 channels are allowed."
  type        = list(string)
  default     = []
}

variable "bucket_location" {
  description = "The location for a GCS bucket to create (optional)"
  type        = string
  default     = "US"
}

variable "bucket_project" {
  description = "A project to create a GCS bucket (bucket_name) in, useful for Terraform state (optional)"
  type        = string
  default     = ""
}

variable "credentials_path" {
  description = "Path to a service account credentials file with rights to run the Project Factory. If this file is absent Terraform will fall back to Application Default Credentials."
  type        = string
  default     = ""
}

variable "default_service_account" {
  description = "Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
  default     = "disable"
  type        = string
}

variable "disable_dependent_services" {
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed."
  default     = true
  type        = bool
}

variable "disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed"
  default     = true
  type        = bool
}

variable "enable_shared_vpc_host_project" {
  description = "If this project is a shared VPC host project. If true, you must *not* set svpc_host_project_id variable. Default is false."
  type        = bool
  default     = false
}

variable "enable_shared_vpc_service_project" {
  description = "If shared VPC should be used."
  type        = bool
  default     = false
}

variable "impersonate_service_account" {
  description = "An optional service account to impersonate"
  type        = string
  default     = ""
}

variable "lien" {
  description = "Add a lien on the project to prevent accidental deletion"
  type        = bool
  default     = false
}

variable "sa_role" {
  description = "A role to give the default Service Account for the project (defaults to none)"
  type        = string
  default     = ""
}

variable "shared_vpc_subnets" {
  description = "List of subnets fully qualified subnet IDs (ie. projects/$project_id/regions/$region/subnetworks/$subnet_id)"
  type        = list(string)
  default     = []
}

variable "svpc_host_project_id" {
  description = "The ID of the host project which hosts the shared VPC"
  type        = string
  default     = ""
}

variable "usage_bucket_name" {
  description = "Name of a GCS bucket to store GCE usage reports in (optional)"
  type        = string
  default     = ""
}

variable "usage_bucket_prefix" {
  description = "Prefix in the GCS bucket to store GCE usage reports in (optional)"
  type        = string
  default     = ""
}

variable "vpc_service_control_attach_enabled" {
  description = "Whether the project will be attached to a VPC Service Control Perimeter"
  type        = bool
  default     = false
}

variable "vpc_service_control_perimeter_name" {
  description = "The name of a VPC Service Control Perimeter to add the created project to"
  type        = string
  default     = null
}

variable "project_type" {
  description = "The type of the project being created; the project will be labelled in the form `<short-name><project-type>: var.project_type`"
  type        = string
  validation {
      condition = contains([
          "infra",
          "cicd",
          "gke",
          "service"
      ], var.project_type)
      error_message = "The supplied project_type is invalid."
  }
}
