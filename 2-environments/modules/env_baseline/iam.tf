/******************************************
  Monitoring - IAM
*****************************************/

resource "google_project_iam_member" "monitoring_editor" {
  project = module.monitoring_project.project_id
  role    = "roles/monitoring.editor"
  member  = "group:${var.monitoring_workspace_users}"
}
