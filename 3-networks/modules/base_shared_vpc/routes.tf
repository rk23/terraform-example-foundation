resource "google_compute_route" "egress_internet" {
  project = var.project_id
  network = local.network_name

  name             = "rt-${local.vpc_name}-egress-internet-default"
  description      = "Tag based route through IGW to access internet"
  dest_range       = "0.0.0.0/0"
  tags             = ["gke-node"]
  next_hop_gateway = "default-internet-gateway"
  priority         = "1000"
}