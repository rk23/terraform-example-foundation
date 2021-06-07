locals {
  reserved_mask_bits = split("/", var.reserved.cidr)[1]
  # Calculate the number of new bits that is required input to the cidrsubnets function   
  new_mask_bits = [for mask_bits in var.allocations[*].mask_bits : mask_bits - local.reserved_mask_bits]
  cidr_ranges   = cidrsubnets(var.reserved.cidr, local.new_mask_bits...)
  # Add the allocation name and the new bits used to subdivide the reserved range
  details_step_0 = [for i, cidr in local.cidr_ranges :
    {
      cidr : cidr,
      new_bits : var.allocations[i].mask_bits - local.reserved_mask_bits,
      name : var.allocations[i].name,
    }
  ]
  # Calculate the start and end IP for all allocated ranges and the reserved range   
  details_step_1 = [for range in concat([var.reserved], local.details_step_0) :
    merge(range, {
      start_ip : cidrhost(range.cidr, 0),
      end_ip : cidrhost(range.cidr, pow(2, 32 - split("/", range.cidr)[1]) - 1)
    })
  ]
  # Calculate the start and end IP address as an Int
  details_step_2 = [for cidr in local.details_step_1 :
    merge(cidr, {
      start_ip_as_int : sum([for i, octet in split(".", cidr.start_ip) : octet * pow(256, 3 - i)]),
      end_ip_as_int : sum([for i, octet in split(".", cidr.end_ip) : octet * pow(256, 3 - i)]),
    })
  ]
  # Calcualte the number of IP addresses in each block
  details_step_3 = [for cidr in local.details_step_2 :
    merge(
      cidr,
      {
        num_reserved : cidr.end_ip_as_int - cidr.start_ip_as_int
      }
    )
  ]

  details_final = local.details_step_3

  # Calc stats about the unallocated addresses
  unallocated = {
    last_allocated : local.details_final[length(local.details_final) - 1].end_ip
    last_reserved : local.details_final[0].end_ip
    ip_available : (
      local.details_final[0].num_reserved -
      sum(
        [
          for cidr in slice(local.details_final, 1, length(local.details_final) - 1) :
          cidr.num_reserved
        ]
      )
    )
  }
}
