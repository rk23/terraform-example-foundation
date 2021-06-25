module "nodes_01" {
  source = "../../../../terraform-gke/modules/node-pool"

  generation         = "01"
  initial_node_count = 1
  machine_type       = "e2-standard-2"
  max_node_count     = 2
  min_node_count     = 1
  preemptible        = true
  tainted            = false
  type               = "nodes"

  cluster_location = local.cluster_location
  cluster_name     = local.cluster_name
  environment      = var.environment
  environment_code = var.environment_code
  node_locations   = local.cluster_zones
  project_id       = local.project_id
  service_account  = local.service_account
}