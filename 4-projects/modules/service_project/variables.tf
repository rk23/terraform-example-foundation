variable "project_name_suffix" {
  description = "A description to be suffixed to name of project"
  type        = string
}

variable "service_project_owners" {
  description = "A list of groups for this project that will be assigned service project owner role"
  type        = list(string)
}

variable "activate_apis" {
  description = "The list of apis to activate in project"
  type        = list(string)
  default     = []
}

variable "compute_enabled" {
  description = "Flag whether to enable compute on this project"
  type        = bool
  default     = false
}

variable "vm_external_ip_access" {
  description = "Flag whether vmExternalIPAccess is enabled for this project"
  type        = bool
  default     = false
}
