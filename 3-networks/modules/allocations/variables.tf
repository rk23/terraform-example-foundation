variable "reserved" {
  type        = object({ cidr : string, name : string })
  description = "object containing top level reservation information"
}

variable "allocations" {
  type        = list(object({ mask_bits : number, name : string }))
  description = "List of network allocations"
  default     = []
}
