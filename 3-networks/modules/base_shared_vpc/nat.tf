/******************************************
  NAT Cloud Router & NAT config
 *****************************************/

resource "google_project_organization_policy" "allow_nat" {
  project    = var.project_id
  constraint = "constraints/compute.restrictCloudNATUsage"

  list_policy {
    allow {
      values = [
        for subnet_id in values(google_compute_subnetwork.nat_enabled_subnetwork)[*].id :
        "is:${subnet_id}"
      ]
    }
  }
}

module "cloud_nat" {
  count   = var.nat_enabled ? 1 : 0
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"
  project = var.project_id
  name    = "cr-${local.vpc_name}-${var.default_region1}-nat-router"
  network = google_compute_network.network.self_link
  region  = var.default_region1

  nats = [{
    name                               = "rn-${local.vpc_name}-${var.default_region1}-egress"
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

    subnetworks = [
      for i, x in local.nat_enabled_subnets : {
        name : x.fullname
        source_ip_ranges_to_nat : ["ALL_IP_RANGES"]
      }
    ]

    log_config = {
      filter = "TRANSLATIONS_ONLY"
    }
  }]
}
