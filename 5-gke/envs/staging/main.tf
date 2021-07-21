data "terraform_remote_state" "projects" {
  backend = "gcs"
  config = {
    bucket = "bkt-kvi-gcp-foundation-tfstate"
    prefix = "terraform/projects/${var.environment}"
  }
}

data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = "bkt-kvi-gcp-foundation-tfstate"
    prefix = "terraform/networks/${var.environment}"
  }
}

locals {
  project_id         = data.terraform_remote_state.projects.outputs.gke_project
  project_number     = data.terraform_remote_state.projects.outputs.gke_project_number
  network            = data.terraform_remote_state.network.outputs
  network_allocation = local.network.gke_cluster_allocations["staging-01"]

  cluster_name     = module.gke.name
  cluster_location = module.gke.location
  cluster_zones    = module.gke.zones
  service_account  = module.gke.service_account
}

module "gke" {
  source = "../../../../terraform-gke/modules/cluster"

  cluster_name_suffix     = "staging"
  cluster_number          = "01"
  datapath_provider       = "ADVANCED_DATAPATH"
  network_policy_provider = "PROVIDER_UNSPECIFIED"
  release_channel         = "RAPID"

  horizontal_pod_autoscaling_enabled  = true
  http_load_balancing_enabled         = true
  istio_enabled                       = false
  network_policy_enabled              = false
  pod_security_policy_enabled         = false
  resource_consumption_export_enabled = false
  shielded_nodes_enabled              = true
  anthos_service_mesh_enabled         = false

  default_max_pods_per_node = local.network_allocation.max_pod_per_node
  domain                    = local.domain
  environment               = var.environment
  environment_code          = var.environment_code
  iam_groups                = var.gke_service_account_groups
  ip_range_pods             = local.network_allocation.pod_ip_cidr_range
  ip_range_services         = local.network_allocation.svc_ip_cidr_range
  master_ipv4_cidr_block    = local.network_allocation.master_ipv4_cidr_block
  network                   = local.network.name
  network_project_id        = local.network.vpc_host_project_id
  project_id                = local.project_id
  project_number            = local.project_number
  region                    = local.network_allocation.region
  subnetwork                = local.network_allocation.subnet

  terraform_service_account = local.terraform_service_account
  cluster_admin_groups      = var.cluster_admin_groups
}


# resource "google_compute_firewall" "enable_nginx" {
#   name    = "fw-${var.environment_code}-i-enable-nginx"
#   network = local.network.name
#   project = local.network.vpc_host_project_id
#   direction = "INGRESS"
#   priority = 65533
#   source_ranges = [local.network_allocation.master_ipv4_cidr_block]

#   allow {
#     protocol = "tcp"
#     ports    = ["8443"]
#   }

#   target_tags = ["gke-node"]
# }
