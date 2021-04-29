resource "google_folder" "bootstrap" {
    display_name = "fldr-bootstrap"
    parent = local.parent
}

resource "google_folder" "common" {
    display_name = "fldr-common"
    parent = local.parent
}
