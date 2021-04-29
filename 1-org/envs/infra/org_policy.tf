/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  organization_id = var.parent_folder != "" ? null : var.org_id
  folder_id       = var.parent_folder != "" ? var.parent_folder : null
  policy_for      = var.parent_folder != "" ? "folder" : "organization"
}

/******************************************
  Access Context Manager Policy
*******************************************/

resource "google_access_context_manager_access_policy" "access_policy" {
  count  = var.create_access_context_manager_access_policy ? 1 : 0
  parent = "organizations/${var.org_id}"
  title  = "default policy"
}

/******************************************
  App Engine
*******************************************/

module "org_app_engine_disable_code_download" {
  source = "terraform-google-modules/org-policy/google"
  version = "~> 3.0"
  organization_id = local.organization_id
  folder_id = local.folder_id
  policy_for = local.policy_for
  policy_type = "boolean"
  enforce = "true"
  constraint = "constraints/appengine.disableCodeDownload"
}


/******************************************
  Cloud Functions  
*******************************************/

module "org_cloud_functions_allowed_ingress_settings" {
  source = "terraform-google-modules/org-policy/google"
  version = "~> 3.0"
  organization_id = local.organization_id
  folder_id = local.folder_id
  policy_for = local.policy_for
  policy_type = "list"
  allow = [
  ]
  allow_list_length = 0
  constraint = "constraints/cloudfunctions.allowedIngressSettings"
}

module "org_cloud_cutions_allowed_vpc_connector_egress_settings" {
  source = "terraform-google-modules/org-policy/google"
  version = "~> 3.0"
  organization_id = local.organization_id
  folder_id = local.folder_id
  policy_for = local.policy_for
  policy_type = "list"
  allow = [
    "ALL_TRAFFIC"
  ]
  allow_list_length = 1
  constraint = "constraints/cloudfunctions.allowedVpcConnectorEgressSettings"
}

module "org_cloud_functions_require_vpc_connector" {
  source = "terraform-google-modules/org-policy/google"
  version = "~> 3.0"
  organization_id = local.organization_id
  folder_id = local.folder_id
  policy_for = local.policy_for
  policy_type = "boolean"
  enforce = "true"
  constraint = "constraints/cloudfunctions.requireVPCConnector"
}

/******************************************
  Compute org policies
*******************************************/

module "org_compute_disable_guest_attributes_access" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.disableGuestAttributesAccess"
}

module "org_disable_internet_network_endpoint_group" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.disableInternetNetworkEndpointGroup"
}

module "org_disable_nested_virtualization" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.disableNestedVirtualization"
}

module "org_disable_serial_port_access" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.disableSerialPortAccess"
}

module "org_require_shielded_vms" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.requireShieldedVm"
}

module "org_restrict_authenticated_google_connection" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = [
    "under:organizations/${local.org_id}"
  ]
  deny_list_length         = 1
  constraint      = "constraints/compute.restrictAuthenticatedGoogleConnection"
}

module "org_restrict_cloud_nat_usage" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = [
    "under:organizations/${local.org_id}"
  ]
  deny_list_length         = 1
  constraint      = "constraints/compute.restrictCloudNATUsage"
}

module "org_restrict_dedicated_interconnect_usage" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = [
    "under:organizations/${local.org_id}"
  ]
  deny_list_length         = 1
  constraint      = "constraints/compute.restrictDedicatedInterconnectUsage"
}

# To be overridden in projects that need LBs
module "org_restrict_lb_types" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = [
    "INTERNAL_TCP_UDP",
    "INTERNAL_HTTP_HTTPS",
    "EXTERNAL_NETWORK_TCP_UDP",
    "EXTERNAL_TCP_PROXY",
    "EXTERNAL_SSL_PROXY",
    "EXTERNAL_HTTP_HTTPS",
  ]
  deny_list_length         = 6
  constraint      = "constraints/compute.restrictLoadBalancerCreationForTypes"
}

module "org_restrict_partner_interconnect" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  # Note this does not support the parent folder concept. Support
  # can be added if/when its needed
  deny = [
    "under:organizations/${local.org_id}"
  ]
  deny_list_length         = 1
  constraint      = "constraints/compute.restrictPartnerInterconnectUsage"
}

module "org_restrict_protocol_forwarding" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = [
    "INTERNAL",
    "EXTERNAL",
  ]
  deny_list_length         = 2
  constraint      = "constraints/compute.restrictProtocolForwardingCreationForTypes"
}

# To be overriden on environment folders to allow connecting with the common shared
# VPC host project per env
module "org_restrict_shared_vpc_host_projects" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = [
    "under:organizations/${local.org_id}"
  ]
  deny_list_length         = 1
  constraint      = "constraints/compute.restrictSharedVpcHostProjects"
}

# To be overriden on enviornment folders to allow connecting with the 
# common shared vpc host project per env
module "org_restrict_shared_vpc_subnetworks" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = [
    "under:organizations/${local.org_id}"
  ]
  deny_list_length         = 1
  constraint      = "constraints/compute.restrictSharedVpcSubnetworks"
}

# To be overriden on network projects that need it
module "org_restrict_vpc_peering" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = [
    "under:organizations/${local.org_id}"
  ]
  deny_list_length         = 1
  constraint      = "constraints/compute.restrictVpcPeering"
}

# To be overriden on network projects that need it
module "org_restrict_vpn_peer_ips" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = []
  deny_list_length         = 0
  constraint      = "constraints/compute.restrictVpnPeerIPs"
}

module "org_shared_vpc_lien_removal" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.restrictXpnProjectLienRemoval"
}

module "org_skip_default_network" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.skipDefaultNetworkCreation"
}

# To be overriden on network projects that need it
module "org_restrict_storage_resource_usage" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = [
    "under:organizations/${local.org_id}"
  ]
  deny_list_length         = 1
  constraint      = "constraints/compute.storageResourceUseRestrictions"
}

module "org_restrict_vm_can_ip_forward" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny = [
    "under:organizations/${local.org_id}"
  ]
  deny_list_length         = 1
  constraint      = "constraints/compute.vmCanIpForward"
}

module "org_vm_external_ip_access" {
  source          = "terraform-google-modules/org-policy/google//modules/restrict_vm_external_ips"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  vms_to_allow = []
}

/******************************************
  Cloud SQL
*******************************************/

module "org_cloudsql_restrict_authorized_networks" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/sql.restrictAuthorizedNetworks"
}

module "org_cloudsql_external_ip_access" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/sql.restrictPublicIp"
}

/******************************************
  GCP-wide org policies 
*******************************************/

module "org_gcp_disable_cloud_logging" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  # The constraint is only supported in the Cloud Logging Healthcare API does not affect Cloud Audit Logs
  constraint      = "constraints/gcp.disableCloudLogging"
}

module "org_gcp_resource_locations" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  allow           = var.resource_locations
  allow_list_length = length(var.resource_locations)
  constraint      = "constraints/gcp.resourceLocations"
}

/******************************************
  IAM
*******************************************/

module "org_domain_restricted_sharing" {
  source           = "terraform-google-modules/org-policy/google//modules/domain_restricted_sharing"
  version          = "~> 3.0"
  organization_id  = local.organization_id
  folder_id        = local.folder_id
  policy_for       = local.policy_for
  domains_to_allow = var.domains_to_allow
}

module "org_iam_allow_sa_credential_lifetime_extension" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  allow         = []
  allow_list_length = 0
  constraint      = "constraints/iam.allowServiceAccountCredentialLifetimeExtension"
}

module "org_disable_automatic_iam_grants_on_default_service_accounts" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
}

# Allow service account creation. A lot of SPI services rely on this being available
# or project creations fails
module "org_disable_sa_creation" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "false"  # Allow service account creation
  constraint      = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
}

module "org_disable_sa_key_creation" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/iam.disableServiceAccountKeyCreation"
}

module "org_disable_sa_key_upload" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/iam.disableServiceAccountKeyUpload"
}

/******************************************
  Service User policies
*******************************************/

module "org_gcp_services" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "list"
  deny         = [
    # "dns.googleapis.com",
    "doubleclicksearch.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
  ]
  deny_list_length = 6
  constraint      = "constraints/serviceuser.services"
}

/******************************************
  Storage
*******************************************/

module "org_enforce_bucket_level_access" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.policy_for
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/storage.uniformBucketLevelAccess"
}
