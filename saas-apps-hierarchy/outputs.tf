output "compartment_ids" {
  description = "Map of compartment names to OCIDs"
  value = merge(
    { for k, v in oci_identity_compartment.root_comps : k => v.id },
    { for k, v in oci_identity_compartment.child_comps : v.name => v.id },
    { for k, v in oci_identity_compartment.grandchild_comps : v.name => v.id }
  )
}


output "policy_ids" {
  description = "Map of policy names to OCIDs"
  value       = { for k, v in oci_identity_policy.policies : k => v.id }
}
