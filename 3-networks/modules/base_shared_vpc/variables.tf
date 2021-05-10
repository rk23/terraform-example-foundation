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

variable "bgp_asn_subnet" {
  type        = number
  description = "BGP ASN for Subnets cloud routers."
}

variable "nat_enabled_subnets" {
  type        = list(map(string))
  description = "The list of subnets being created with NAT access"
  default     = []
}

variable "nat_subnet_secondary_ranges" {
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

variable "vpc_description" {
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
  type = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the  "
}


variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}

variable "folder_prefix" {
  description = "Name prefix to use for folders created."
  type        = string
  default     = "fldr"
}

variable "allow_all_egress_ranges" {
  description = "List of network ranges to which all egress traffic will be allowed"
  default     = null
}

variable "allow_all_ingress_ranges" {
  description = "List of network ranges from which all ingress traffic will be allowed"
  default     = null
}
