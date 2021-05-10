locals {
  mode                    = var.mode == null ? "" : var.mode == "hub" ? "-hub" : "-spoke"
  vpc_name                = "${var.environment_code}-shared-base${local.mode}"
  network_name            = "vpc-${local.vpc_name}"
  private_googleapis_cidr = "199.36.153.8/30"
}

/******************************************
  VPC Configuration
*****************************************/

resource "google_compute_network" "network" {
  name                            = local.network_name
  auto_create_network             = var.auto_create_network
  routing_mode                    = var.routing_mode
  project                         = var.project_id
  description                     = var.vpc_detailed_description
  delete_default_routes_on_create = "false"
  mtu                             = var.mtu
}

/******************************************
  Shared VPC configuration
 *****************************************/

resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  project    = var.project_id
  depends_on = [google_compute_network.network]
}

/***************************************************************
  Configure Service Networking for Cloud SQL & future services.
 **************************************************************/

resource "google_compute_global_address" "private_service_access_address" {
  name          = "ga-${local.vpc_name}-vpc-peering-internal"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", var.private_service_cidr), 0)
  prefix_length = element(split("/", var.private_service_cidr), 1)
  network       = google_compute_network.network.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.network.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access_address.name]
}

# module "main" {
#   source                                 = "terraform-google-modules/network/google"
#   version                                = "~> 3.1"
#   project_id                             = var.project_id
#   network_name                           = local.network_name
#   shared_vpc_host                        = "true"
#   delete_default_internet_gateway_routes = "true"

#   subnets          = var.subnets
#   secondary_ranges = var.secondary_ranges

#   routes = concat(
#     [{
#       name              = "rt-${local.vpc_name}-1000-all-default-private-api"
#       description       = "Route through IGW to allow private google api access."
#       destination_range = "199.36.153.8/30"
#       next_hop_internet = "true"
#       priority          = "1000"
#     }],
#     var.nat_enabled ?
#     [
#       {
#         name              = "rt-${local.vpc_name}-1000-egress-internet-default"
#         description       = "Tag based route through IGW to access internet"
#         destination_range = "0.0.0.0/0"
#         tags              = "egress-internet"
#         next_hop_internet = "true"
#         priority          = "1000"
#       }
#     ]
#     : [],
#     var.windows_activation_enabled ?
#     [{
#       name              = "rt-${local.vpc_name}-1000-all-default-windows-kms"
#       description       = "Route through IGW to allow Windows KMS activation for GCP."
#       destination_range = "35.190.247.13/32"
#       next_hop_internet = "true"
#       priority          = "1000"
#       }
#     ]
#     : []
#   )
# }

# /***************************************************************
#   VPC Peering Configuration
#  **************************************************************/

# module "peering" {
#   source                    = "terraform-google-modules/network/google//modules/network-peering"
#   version                   = "~> 2.0"
#   count                     = var.mode == "spoke" ? 1 : 0
#   prefix                    = "np"
#   local_network             = module.main.network_self_link
#   peer_network              = data.google_compute_network.vpc_base_net_hub[0].self_link
#   export_peer_custom_routes = true
# }

# /************************************
#   Router to advertise shared VPC
#   subnetworks and Google Private API
# ************************************/

# module "region1_router1" {
#   source  = "terraform-google-modules/cloud-router/google"
#   version = "~> 0.3.0"
#   count   = var.mode != "spoke" ? 1 : 0
#   name    = "cr-${local.vpc_name}-${var.default_region1}-cr1"
#   project = var.project_id
#   network = module.main.network_name
#   region  = var.default_region1
#   bgp = {
#     asn                  = var.bgp_asn_subnet
#     advertised_groups    = ["ALL_SUBNETS"]
#     advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
#   }
# }

# module "region1_router2" {
#   source  = "terraform-google-modules/cloud-router/google"
#   version = "~> 0.3.0"
#   count   = var.mode != "spoke" ? 1 : 0
#   name    = "cr-${local.vpc_name}-${var.default_region1}-cr2"
#   project = var.project_id
#   network = module.main.network_name
#   region  = var.default_region1
#   bgp = {
#     asn                  = var.bgp_asn_subnet
#     advertised_groups    = ["ALL_SUBNETS"]
#     advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
#   }
# }

# module "region2_router1" {
#   source  = "terraform-google-modules/cloud-router/google"
#   version = "~> 0.3.0"
#   count   = var.mode != "spoke" ? 1 : 0
#   name    = "cr-${local.vpc_name}-${var.default_region2}-cr3"
#   project = var.project_id
#   network = module.main.network_name
#   region  = var.default_region2
#   bgp = {
#     asn                  = var.bgp_asn_subnet
#     advertised_groups    = ["ALL_SUBNETS"]
#     advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
#   }
# }

# module "region2_router2" {
#   source  = "terraform-google-modules/cloud-router/google"
#   version = "~> 0.3.0"
#   count   = var.mode != "spoke" ? 1 : 0
#   name    = "cr-${local.vpc_name}-${var.default_region2}-cr4"
#   project = var.project_id
#   network = module.main.network_name
#   region  = var.default_region2
#   bgp = {
#     asn                  = var.bgp_asn_subnet
#     advertised_groups    = ["ALL_SUBNETS"]
#     advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
#   }
# }
