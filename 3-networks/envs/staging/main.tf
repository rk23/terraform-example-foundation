locals {
  cluster_staging_01 = "staging-01"
  subnet_name        = "sb-${var.environment_code}-${var.vpc_name_suffix}-us-east1-nat-enabled"

  pods_index_common    = 0
  svc_index_staging_01 = 1

  gke_subnets = {
    (local.cluster_staging_01) = module.base_shared_vpc.nat_enabled_subnets[local.subnet_name]
  }

  gke_cluster_allocations = {
    (local.cluster_staging_01) = {
      pod_ip_cidr_range      = local.gke_subnets[local.cluster_staging_01].secondary_ip_range[local.pods_index_common].range_name
      svc_ip_cidr_range      = local.gke_subnets[local.cluster_staging_01].secondary_ip_range[local.svc_index_staging_01].range_name
      subnet                 = local.gke_subnets[local.cluster_staging_01].name
      region                 = local.gke_subnets[local.cluster_staging_01].region
      master_ipv4_cidr_block = module.primary_allocation.details_map["${local.cluster_staging_01}-masters"].cidr
      max_pod_per_node = min(floor(
        module.secondary_allocation.details_map[var.pods_secondary_allocation].num_reserved /
        module.primary_allocation.details_map[var.nat_enabled_primary_allocation].num_reserved),
        110
      )
    }
  }
}

data "terraform_remote_state" "staging" {
  backend = "gcs"
  config = {
    bucket = "bkt-kvi-gcp-foundation-tfstate"
    prefix = "terraform/environments/staging"
  }
}

module "primary_allocation" {
  source = "../../modules/allocations"
  reserved = {
    cidr = var.primary_cidr_allocation,
    name = "gcp-${var.environment_code}-primary-network"
  }
  allocations = [
    {
      name      = var.nat_enabled_primary_allocation,
      mask_bits = 22
    },
    {
      name      = var.private_primary_allocation,
      mask_bits = 20
    },
    {
      name      = "reserved for future use"
      mask_bits = 18
    },
    {
      name      = "${local.cluster_staging_01}-masters"
      mask_bits = 28
    },
    {
      name      = var.shared_private_google_services_primary_allocation
      mask_bits = 20
    }
  ]
}

module "secondary_allocation" {
  source = "../../modules/allocations"
  reserved = {
    cidr = var.secondary_cidr_allocation
    name = "gcp-${var.environment_code}-secondary-network"
  }
  allocations = [
    {
      name      = var.pods_secondary_allocation,
      mask_bits = 17,
    },
    {
      name      = "${local.cluster_staging_01}-svc",
      mask_bits = 20
    }
  ]
}

/******************************************
 Base shared VPC
*****************************************/

module "base_shared_vpc" {
  source = "../../modules/base_shared_vpc"

  default_region1           = var.default_region1
  domain                    = local.domain
  environment_code          = var.environment_code
  firewall_enable_logging   = var.firewall_enable_logging
  nat_enabled               = var.nat_enabled
  nat_bgp_asn               = var.nat_bgp_asn
  nat_num_addresses_region1 = var.nat_num_addresses_region1
  parent_folder             = var.parent_folder
  project_id                = data.terraform_remote_state.staging.outputs.vpc_host_project_id
  private_service_cidr      = module.primary_allocation.details_map[var.shared_private_google_services_primary_allocation].cidr
  org_id                    = local.org_id
  subnet_access_groups      = var.subnet_access_groups
  terraform_service_account = local.terraform_service_account
  vpc_name_suffix           = var.vpc_name_suffix

  gke_masters_cidrs = {
    (local.cluster_staging_01) = module.primary_allocation.details_map["${local.cluster_staging_01}-masters"].cidr
  }

  nat_enabled_subnets = [
    {
      subnet_name           = var.nat_enabled_primary_allocation
      subnet_ip             = module.primary_allocation.details_map[var.nat_enabled_primary_allocation].cidr
      subnet_region         = var.default_region1
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "Hybrid ${var.environment} subnet with NAT access."
    },
  ]

  subnet_secondary_ranges = {
    (var.nat_enabled_primary_allocation) = [
      {
        range_name_suffix = var.pods_secondary_allocation
        subnet_region     = var.default_region1
        ip_cidr_range     = module.secondary_allocation.details_map[var.pods_secondary_allocation].cidr
      },
      {
        range_name_suffix = "${local.cluster_staging_01}-svc"
        subnet_region     = var.default_region1
        ip_cidr_range     = module.secondary_allocation.details_map["${local.cluster_staging_01}-svc"].cidr
      },
    ]
  }

  private_subnets = [
    {
      subnet_name           = var.private_primary_allocation
      subnet_ip             = module.primary_allocation.details_map[var.private_primary_allocation].cidr
      subnet_region         = var.default_region1
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "Private ${var.environment} subnet with no NAT access."
    }
  ]
}
