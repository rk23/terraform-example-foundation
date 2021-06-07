variable "default_region1" {
  type        = string
  description = "First subnet region. The shared vpc modules only configures two regions."
}

variable "dns_enable_logging" {
  type        = bool
  description = "Toggle DNS logging for VPC DNS."
  default     = true
}

variable "dns_enable_inbound_forwarding" {
  type        = bool
  description = "Toggle inbound query forwarding for VPC DNS."
  default     = true
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = true
}

variable "nat_enabled" {
  type        = bool
  description = "Toggle creation of NAT cloud router."
  default     = false
}

variable "nat_bgp_asn" {
  type        = number
  description = "BGP ASN for first NAT cloud routes."
  default     = 64514
}

variable "nat_num_addresses_region1" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT."
  default     = 2
}

variable "optional_fw_rules_enabled" {
  type        = bool
  description = "Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges."
  default     = false
}

# variable "org_id" {
#   type        = string
#   description = "Organization ID"
# }

variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}

variable "primary_cidr_allocation" {
  description = "The /16 IPv4 block used for cicd subnets"
  type        = string
}

variable "secondary_cidr_allocation" {
  description = "The /16 IPv4 block used for cicd secondary ranges"
  type        = string
}

variable "vpc_name_suffix" {
  description = "A description to be suffixed to the name of the vpc."
  type        = string
  default     = "shared"
}

variable "nat_enabled_primary_allocation" {
  description = "The name of th eprimary allocation for the NAT-enabled subnet."
  type        = string
  default     = "nat-enabled"
}

variable "pods_secondary_allocation" {
  description = "The name of the secondary allocation for GKE pods."
  type        = string
  default     = "pods"
}

variable "private_primary_allocation" {
  description = "The name of the primary allocation for the private subnet"
  type        = string
  default     = "private"
}

variable "shared_private_google_services_primary_allocation" {
  description = "The name of the primary allocation fo the subnet used by google services."
  type        = string
  default     = "shared-private-google-services"
}

variable "subnet_access_groups" {
  description = "G Suite or Cloud Identity groups that have access to the subnets of the shared VPC."
  type        = list(string)
}

variable "subnetworks_enable_logging" {
  type        = bool
  description = "Toggle subnetworks flow logging for VPC Subnetworks."
  default     = true
}
