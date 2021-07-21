/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "common_folder_name" {
  value       = local.common_folder.id
  description = "The common folder name"
}

output "security_folder_name" {
  value       = google_folder.security.name
  description = "The security folder name"
}

output "org_billing_logs_project_id" {
  value       = module.org_billing_logs.project_id
  description = "The org billing logs project ID"
}

output "org_audit_logs_project_id" {
  value       = module.org_audit_logs.project_id
  description = "The org audit logs project ID"
}

output "scc_project_id" {
  value       = module.scc.project_id
  description = "The scc project ID"
}

output "domains_to_allow" {
  value       = var.domains_to_allow
  description = "The list of domains to allow users from in IAM."
}

output "folders" {
  value = {
    common      = local.common_folder.id
    billing     = google_folder.billing.id
    security    = google_folder.security.id
    engineering = google_folder.engineering.id
  }
}

output "gke_service_agent_firewall_role" {
  value       = google_organization_iam_custom_role.gce_firewall_admin_role.id
  description = "Name of the custom role defined for gke service agents to manage firewalls"
}

output "service_project_owner_role" {
  value = google_organization_iam_custom_role.service_project_owner.id
  description = "Name of the custom role defined for service project owners"
}