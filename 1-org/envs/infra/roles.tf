locals {
  gce_firewall_admin_permissions = [
    "compute.firewalls.create",
    "compute.firewalls.delete",
    "compute.firewalls.get",
    "compute.firewalls.list",
    "compute.firewalls.update",
    "compute.networks.updatePolicy",
  ]
}

resource "googe_organization_iam_custom_role" "service_project_owner" {
  role_id = "rl.serviceProjectOwner"
  title = "Custom role for service project owners"
}

resource "google_organization_iam_custom_role" "gce_firewall_admin_role" {
  role_id     = "role.GCEFirewallAdmin"
  title       = "GCE Firewall Admin - Custom"
  description = "Allows members ot edit firewall rules in a project"

  permissions = local.gce_firewall_admin_permissions

  org_id = local.org_id
}
