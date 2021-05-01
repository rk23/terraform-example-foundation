terraform {
    required_version = ">= 0.14"

    required_providers {
      google = {
          source = "hashicorp/google"
          version = "~> 3.30"
      }
      google-beta = {
          source = "hashicorp/google-beta"
          version = "~> 3.30"
      }
    }    
}

provider "google" {
    alias = "impersonate"

    scopes = [
        "https://wwww.googleapis.com/auth/cloud-platform",
        "https://wwww.googleapis.com/auth/userinfo.email",
    ]
}

data "google_service_account_access_token" "default" {
    provider = google.impersonate
    target_service_account = local.terraform_service_account
    scopes = ["userinfo-email", "cloud-platform"]
    lifetime = "600s"
}

provider "google"{
    access_token = data.google_service_account_access_token.default.access_token
}

provider "google-beta" {
    access_token = data.google_service_account_access_token.default.access_token
}
