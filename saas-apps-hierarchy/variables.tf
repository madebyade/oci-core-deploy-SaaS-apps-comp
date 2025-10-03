variable "tenancy_ocid" {
  type        = string
  description = "Root tenancy OCID (for policy creation)"
}

variable "compartment_hierarchy" {
  description = "Nested map describing compartments"
  type        = map(any)
}

variable "policies" {
  description = "Map of groups to list of access rules"
  type = map(list(object({
    access      = string
    compartment = string
  })))
  default = {}
}
