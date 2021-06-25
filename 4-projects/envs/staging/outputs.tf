output "gke_project" {
    description = "GKE project id"
    value = module.gke_project.gke_project_id
}

output "gke_project_number" {
    description = "GKE project number"
    value = module.gke_project.gke_project_number
}
