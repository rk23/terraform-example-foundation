output "network_name" {
  value       = google_compute_network.network.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.network.network_self_link
  description = "The URI of the VPC being created"
}

output "network_association_name" {
  value = join(
    "/",
    [
      "projects",
      var.project_id,
      "global",
      "networks",
      google_compute_network.network.name,
    ]
  )
  description = "Thhe name to associate the vpc with a google cloud service. For example: Cloud SQL Instance"
}

output "nat_enabled_subnets" {
  value       = google_compute_subnetwork.nat_enabled_subnetwork
  description = "Subnets with NAT access"
}

output "private_subnets" {
  value       = google_compute_network.private_subnetwork
  description = "Subnets without external access"
}
