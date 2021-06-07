locals {
  nat_enabled_subnets = {
    for i, x in var.nat_enabled_subnets :
    "sb-${var.environment_code}-${var.vpc_name_suffix}-${x.subnet_region}-${x.subnet_name}" =>
    merge(x, {
      fullname : "sb-${var.environment_code}-${var.vpc_name_suffix}-${x.subnet_region}-${x.subnet_name}"
    })
  }
  private_subnets = {
    for i, x in var.private_subnets :
    "sb-${var.environment_code}-${var.vpc_name_suffix}-${x.subnet_region}-${x.subnet_name}" =>
    merge(x, {
      fullname : "sb-${var.environment_code}-${var.vpc_name_suffix}-${x.subnet_region}-${x.subnet_name}"
    })
  }
  secondary_ip_ranges = {
    for subnet_name, ranges in var.subnet_secondary_ranges :
    subnet_name => [for range in ranges : lookup(range, "range_name", null) == null ?
      merge(range, {
        range_name : "rn-${var.environment_code}-${var.vpc_name_suffix}-${range.subnet_region}-${subnet_name}-${range.range_name_suffix}"
    }) : range]
  }
  subnet_self_links = concat(
    values(google_compute_subnetwork.nat_enabled_subnetwork)[*].self_link,
    values(google_compute_subnetwork.private_subnetwork)[*].self_link
  )
  subnet_names = concat(
    var.nat_enabled_subnets[*].subnet_name,
    var.private_subnets[*].subnet_name
  )
  subnet_access_groups = [for group in var.subnet_access_groups : "group:${group}"]
  subnet_member_permissions = merge(
    {
      for groupnet in setproduct(keys(local.nat_enabled_subnets), local.subnet_access_groups) :
      "${local.nat_enabled_subnets[groupnet[0]].fullname}/${groupnet[1]}" =>
      {
        subnetwork : local.nat_enabled_subnets[groupnet[0]].fullname
        region : local.nat_enabled_subnets[groupnet[0]].subnet_region
        iam_group : groupnet[1]
      }
    },
    {
      for groupnet in setproduct(keys(local.private_subnets), local.subnet_access_groups) :
      "${local.private_subnets[groupnet[0]].fullname}/${groupnet[1]}" =>
      {
        subnetwork : local.private_subnets[groupnet[0]].fullname
        region : local.private_subnets[groupnet[0]].subnet_region
        iam_group : groupnet[1]
      }
    }
  )
}

resource "google_compute_subnetwork" "nat_enabled_subnetwork" {
  for_each                 = local.nat_enabled_subnets
  name                     = each.value.fullname
  ip_cidr_range            = each.value.subnet_ip
  region                   = each.value.subnet_region
  private_ip_google_access = lookup(each.value, "subnet_private_access", "false")
  dynamic "log_config" {
    for_each = lookup(each.value, "subnet_flow_logs", false) ? [{
      aggregation_interval = lookup(each.value, "subnet_flow_logs_interval", "INTERVAL_5_SEC")
      flow_sampling        = lookup(each.value, "subnet_flow_logs_sampling", "0.5")
      metadata             = lookup(each.value, "subnet_flow_logs_metadata", "INCLUDE_ALL_METADATA")
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
    }
  }
  network            = local.network_name
  project            = var.project_id
  description        = lookup(each.value, "description", null)
  secondary_ip_range = lookup(local.secondary_ip_ranges, each.value.subnet_name, [])
}

resource "google_compute_subnetwork" "private_subnetwork" {
  for_each                 = local.private_subnets
  name                     = each.value.fullname
  ip_cidr_range            = each.value.subnet_ip
  region                   = each.value.subnet_region
  private_ip_google_access = lookup(each.value, "subnet_private_access", "false")
  dynamic "log_config" {
    for_each = lookup(each.value, "subnet_flow_logs", false) ? [{
      aggregation_interval = lookup(each.value, "subnet_flow_logs_interval", "INTERVAL_5_SEC")
      flow_sampling        = lookup(each.value, "subnet_flow_logs_sampling", "0.5")
      metadata             = lookup(each.value, "subnet_flow_logs_metadata", "INCLUDE_ALL_METADATA")
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
    }
  }
  network            = local.network_name
  project            = var.project_id
  description        = lookup(each.value, "description", null)
  secondary_ip_range = lookup(local.secondary_ip_ranges, each.value.subnet_name, [])
}

resource "google_compute_subnetwork_iam_member" "group_role_to_vpc_subnets" {
  for_each = local.subnet_member_permissions
  provider = google-beta

  subnetwork = each.value.subnetwork
  role       = "roles/compute.networkUser"
  region     = each.value.region
  member     = each.value.iam_group
  project    = var.project_id
}
