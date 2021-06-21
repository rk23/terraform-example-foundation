resource "google_compute_ssl_policy" "kvi-ssl-policy" {
  name            = "sslpol-${var.environment_code}-kvi"
  description     = "The SSL Policy all Karavi external services should use unless they've been granted an exception"
  min_tls_version = "TLS_1_2"
  profile         = "CUSTOM"
  custom_features = [
    "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
    "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
  ]
  project = module.gke_project.project_id
}
