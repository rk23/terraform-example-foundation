data "terraform_remote_state" "org" {
    backend = "gcs"
    config = {
        bucket = "bkt-kvi-gcp-foundation-tfstate"
        prefix = "terraform/org/state"
    }
}
