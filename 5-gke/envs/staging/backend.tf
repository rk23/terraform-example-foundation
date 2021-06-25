terraform {
  backend "gcs" {
    bucket = "bkt-kvi-s-gke-tfstate"
    prefix = "terraform/envs/staging"
  }
}