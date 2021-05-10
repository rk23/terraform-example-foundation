/******************************************
  NAT Cloud Router & NAT config
 *****************************************/

resource "google_compute_router" "nat_router_region1" {
  count   = var.nat_enabled ? 1 : 0
  name    = "cr-${local.vpc_name}-${var.default_region1}-nat-router"
  project = var.project_id
  region  = var.default_region1
  network = google_compute_network.network.network_self_link

  # bgp {
  #   asn = var.nat_bgp_asn
  # }
}

resource "google_project_organization_policy" "allow_nat" {
  project    = var.project_id
  constraint = "constraints/compute.restrictCloudNATUsage"

  list_policy {
    allow {
      values = [
        for subnet_id in vlaues(google_compute_subnetwork.nat_enabled_subnetwork)[*].id :
        "is:${subnet_id}"
      ]
    }
  }
}

resource "google_compute_router_nat" "egress_nat_region1" {
  name                               = "rn-${local.vpc_name}-${var.default_region1}-egress"
  project                            = var.project_id
  router                             = google_compute_router.nat_router_region1.0.name
  region                             = var.default_region1
  nat_ip_allocate_option             = "AUTO_ONLY"
  nat_ips                            = google_compute_address.nat_external_addresses_region1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = local.nat_enabled_subnets
    content {
      name                    = subnetwork.value.fullname
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}
