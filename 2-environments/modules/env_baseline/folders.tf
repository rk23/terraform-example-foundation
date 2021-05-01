/******************************************
  Environment Folder
*****************************************/

resource "google_folder" "env" {
  display_name = "${var.folder_prefix}-${var.environment}"
  parent       = local.parent
}
