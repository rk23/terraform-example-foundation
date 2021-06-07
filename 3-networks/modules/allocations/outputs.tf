output "details" {
  value       = local.details_final
  description = "details about the network allocations"
}

output "details_map" {
  value       = { for detail in local.details_final : detail.name => detail }
  description = "details about the network allocations as a map"
}

output "available" {
  value       = local.unallocated
  description = "Information about unallocated network resources"
}

output "subnetviz" {
  value       = join("\n", concat([for range in local.details_final : "${range.cidr}  ${range.name}"], [""]))
  description = "subnetviz input for all allocations"
}
