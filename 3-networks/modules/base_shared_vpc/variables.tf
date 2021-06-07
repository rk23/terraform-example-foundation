variable "org_id" {
  type        = string
  description = "Organization ID"
}

variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}

variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization."
}

variable "default_region1" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
}

variable "nat_enabled" {
  type        = bool
  description = "Toggle creation of NAT cloud router."
  default     = false
}

variable "nat_bgp_asn" {
  type        = number
  description = "BGP ASN for first NAT cloud routes."
  default     = 0
}

variable "nat_num_addresses_region1" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT."
  default     = 2
}


variable "nat_enabled_subnets" {
  type        = list(map(string))
  description = "The list of subnets being created with NAT access"
  default     = []
}

variable "subnet_secondary_ranges" {
  type        = map(list(map(string)))
  description = "Secondary ranges for nat enabled subnets"
  default     = {}
}

variable "private_subnets" {
  type        = list(map(string))
  description = "The list of subnets being created without NAT access"
  default     = []
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = true
}

variable "domain" {
  type        = string
  description = "The DNS name of peering managed zone, for instance 'example.com.'"
}

variable "private_service_cidr" {
  type        = string
  description = "CIDR range for private service networking. Used for Cloud SQL and other managed services."
  default     = null
}

variable "vpc_name_suffix" {
  type        = string
  description = "Descriptive portion of the name of the VPC, e.g. 'shared-base'"
  default     = "shared-base"
}

variable "vpc_detailed_description" {
  type        = string
  description = "The description field of the VPC"
  default     = ""
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
}

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "mtu" {
  type        = number
  description = "The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically."
  default     = 0
}

variable "terraform_service_account" {
  description = "Terraform service account used to apply the terraform"
  type        = string
}

variable "subnet_access_groups" {
  description = "G Suite or Cloud Identity groups that have access to the subnets of the shared VPC"
  type        = list(string)
}

variable "gke_masters_cidrs" {
  description = "The CIDR for the GKE master nodes for each cluster."
  type        = map(string)
  default     = {}
}

variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}
