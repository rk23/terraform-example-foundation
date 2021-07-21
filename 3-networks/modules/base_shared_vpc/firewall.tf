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

/******************************************
  Mandatory firewall rules
 *****************************************/

resource "google_compute_firewall" "deny_all_egress" {
  name      = "fw-${var.environment_code}-e-deny-all"
  network   = google_compute_network.network.name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 65535

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  deny {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
}

// Allow SSH via IAP when using the allow-iap-ssh tag for Linux workloads.
resource "google_compute_firewall" "allow_iap_ssh" {
  name      = "fw-${var.environment_code}-i-allow-iap-ssh"
  network   = google_compute_network.network.name
  project   = var.project_id
  direction = "INGRESS"
  priority  = "1000"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  // Cloud IAP's TCP forwarding netblock
  source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["allow-iap-ssh", "gke-node"]
}

// Allow traffic for Internal & Global load balancing health check and load balancing IP ranges.
resource "google_compute_firewall" "allow_lb" {
  name      = "fw-${var.environment_code}-i-allow-lb-healthcheck"
  network   = google_compute_network.network.name
  project   = var.project_id
  direction = "INGRESS"
  priority  = 1000

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = concat(data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4, data.google_netblock_ip_ranges.legacy_health_checkers.cidr_blocks_ipv4)

  // Allow common app ports by default.
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }

  target_tags = ["allow-lb", "gke-node"]
}

resource "google_compute_firewall" "allow_internet_egress" {
  count     = var.nat_enabled ? 1 : 0
  name      = "fw-${var.environment_code}-e-allow-internet"
  network   = google_compute_network.network.name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 65533

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  destination_ranges = ["0.0.0.0/0"]

  target_tags = ["gke-node"]
}

resource "google_compute_firewall" "deny_all_ingress" {
  name      = "fw-${var.environment_code}-i-deny-all"
  network   = google_compute_network.network.name
  project   = var.project_id
  direction = "INGRESS"
  priority  = 65533

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

# TODO: Firewall rule gke-gke-s-staging-01-78562ce1-master manually updated to allow ingress to 8443 for nginx ingress controller
