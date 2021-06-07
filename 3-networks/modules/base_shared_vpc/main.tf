locals {
  vpc_name     = "${var.environment_code}-${var.vpc_name_suffix}"
  network_name = "vpc-${local.vpc_name}"
}

/******************************************
  VPC Configuration
*****************************************/

resource "google_compute_network" "network" {
  name                            = local.network_name
  auto_create_subnetworks         = var.auto_create_subnetworks
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
  network       = google_compute_network.network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access_address.name]
}
