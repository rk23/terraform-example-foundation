output "cluster_name" {
    description = "Name of the GKE cluster"
    value = local.cluster_name
}

output "master_ipv4_cidr_block" {
    description = "The IP range in CIDR notation used for master network"
    value = module.gke.master_ipv4_cidr_block
}
