# Root compartments
resource "oci_identity_compartment" "root_comps" {
  for_each = {
    for cname, cdef in var.compartment_hierarchy :
    cname => cdef
  }


  name           = each.key
  description    = lookup(each.value, "description", each.key)
  compartment_id = var.tenancy_ocid
  enable_delete  = true
}

# First-level children
resource "oci_identity_compartment" "child_comps" {
  for_each = merge([
    for cname, cdef in var.compartment_hierarchy : {
      for subname, subdef in lookup(cdef, "children", {}) :
      "${cname}/${subname}" => {
        name        = subname
        description = lookup(subdef, "description", subname)
        parent      = cname
      }
    }
  ]...)

  name           = each.value.name
  description    = each.value.description
  compartment_id = oci_identity_compartment.root_comps[each.value.parent].id
  enable_delete  = true
}

# Second-level children (grandchildren)
resource "oci_identity_compartment" "grandchild_comps" {
  for_each = merge([
    for path, cdef in merge([
      for cname, cdef in var.compartment_hierarchy : {
        for subname, subdef in lookup(cdef, "children", {}) :
        "${cname}/${subname}" => subdef
      }
    ]...) : {
      for gname, gdef in lookup(cdef, "children", {}) :
      "${path}/${gname}" => {
        name        = gname
        description = lookup(gdef, "description", gname)
        parent      = path
      }
    }
  ]...)

  name           = each.value.name
  description    = each.value.description
  compartment_id = (
    contains(keys(oci_identity_compartment.child_comps), each.value.parent) ?
    oci_identity_compartment.child_comps[each.value.parent].id :
    var.tenancy_ocid
  )
  enable_delete  = true
}

# Wait for IAM propagation
resource "time_sleep" "wait_for_compartments" {
  depends_on = [
    oci_identity_compartment.root_comps,
    oci_identity_compartment.child_comps,
    oci_identity_compartment.grandchild_comps,
  ]
  create_duration = "45s"
}

# Map names → OCIDs for policy lookups
locals {
  compartment_name_to_id = merge(
    { for k, v in oci_identity_compartment.root_comps : k => v.id },
    { for k, v in oci_identity_compartment.child_comps : v.name => v.id },
    { for k, v in oci_identity_compartment.grandchild_comps : v.name => v.id }
  )
}

# Policies at root
resource "oci_identity_policy" "policies" {
  for_each = var.policies

  name           = "${each.key}-policy"
  description    = "Auto policy for ${each.key}"
  compartment_id = var.tenancy_ocid

  statements = [
    for rule in each.value :
    "Allow group ${each.key} to ${rule.access} in compartment id ${local.compartment_name_to_id[rule.compartment]}"
  ]

  depends_on = [time_sleep.wait_for_compartments]
}
