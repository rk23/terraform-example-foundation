terraform {
  backend "gcs" {
    bucket = "bkt-kvi-gcp-foundation-tfstate"
    prefix = "terraform/projects/staging"
  }
}
