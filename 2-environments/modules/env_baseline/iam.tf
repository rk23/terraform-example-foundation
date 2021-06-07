/******************************************
  Observability - IAM
*****************************************/

resource "google_project_iam_member" "observability_editor" {
  count = var.monitoring_workspace_users != "" ? 1 : 0

  project = module.observability_project.project_id
  role    = "roles/monitoring.editor"
  member  = "group:${var.monitoring_workspace_users}"
}
