output "compartment_id" {
  description = "OCID of the shared-services compartment"
  value       = oci_identity_compartment.shared_services.id
}

output "compartment_name" {
  description = "Name of the shared-services compartment"
  value       = oci_identity_compartment.shared_services.name
}

output "secadmin_policy_id" {
  description = "OCID of the SECAdmins policy"
  value       = oci_identity_policy.secadmins.id
}

output "iamadmin_policy_id" {
  description = "OCID of the IAMAdmins policy"
  value       = oci_identity_policy.iamadmins.id
}

