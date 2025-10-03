locals {
  compartment_name = "shared-services"
}

# -------------------------------------------------------------------
# Compartment: shared-services
# -------------------------------------------------------------------
resource "oci_identity_compartment" "shared_services" {
  compartment_id = var.tenancy_ocid
  name           = local.compartment_name
  description    = "Compartment for shared OCI services"
  enable_delete  = true

  #  defined_tags  = var.defined_tags
  #  freeform_tags = var.freeform_tags
}

# -------------------------------------------------------------------
# IAM Policies for SECAdmins
# -------------------------------------------------------------------
resource "oci_identity_policy" "secadmins" {
  compartment_id = var.tenancy_ocid
  name           = "policy-secadmins-shared-services"
  description    = "SECAdmins manage security-relevant services in shared-services"
  statements = [
    "Allow group ${var.secadmin_group_name} to manage cloud-guard-family in compartment ${local.compartment_name}",
    "Allow group ${var.secadmin_group_name} to manage log-groups in compartment ${local.compartment_name}",
    "Allow group ${var.secadmin_group_name} to manage logs in compartment ${local.compartment_name}",
    "Allow group ${var.secadmin_group_name} to manage serviceconnectors in compartment ${local.compartment_name}",
    "Allow group ${var.secadmin_group_name} to manage streams in compartment ${local.compartment_name}",
    "Allow group ${var.secadmin_group_name} to manage virtual-network-family in compartment ${local.compartment_name}",
    "Allow group ${var.secadmin_group_name} to read metrics in compartment ${local.compartment_name}"
  ]

  depends_on = [oci_identity_compartment.shared_services]

}

# -------------------------------------------------------------------
# IAM Policies for IAMAdmins
# -------------------------------------------------------------------
resource "oci_identity_policy" "iamadmins" {
  compartment_id = var.tenancy_ocid
  name           = "policy-iamadmins-shared-services"
  description    = "IAMAdmins manage IAM policies in shared-services"
  statements = [
    "Allow group ${var.iamadmin_group_name} to manage policies in compartment ${local.compartment_name}",
    "Allow group ${var.iamadmin_group_name} to read compartments in tenancy"
  ]

  depends_on = [oci_identity_compartment.shared_services]
  
}
