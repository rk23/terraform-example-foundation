/******************************************
 Private Outputs
*****************************************/

output "vpc_host_project_id" {
  value       = data.terraform_remote_state.staging.outputs.vpc_host_project_id
  description = "The base host project ID"
}

output "name" {
  value       = module.base_shared_vpc.network_name
  description = "The name of the VPC being created"
}

output "gke_cluster_allocations" {
  value       = local.gke_cluster_allocations
  description = "Allocations for GKE"
}
