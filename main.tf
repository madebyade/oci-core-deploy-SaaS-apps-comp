module "saas_apps" {
  source = "./saas-apps-hierarchy"

  tenancy_ocid = var.tenancy_ocid


  compartment_hierarchy = {
    "SaaS_Root_Compartment" = {
      description = "Top-level SaaS apps"
      children = {
        "Finance-EPM" = {
          description = "Finance EPM"
          children = {
            "ARCS" = { description = "Account Reconciliation" }
          }
        }
      }
    }
  }

  policies = {
    "EPM-Admins" = [
      { access = "manage epm-planning-environment-family", compartment = "Finance-EPM" },
      { access = "manage work-requests", compartment = "Finance-EPM" }
    ]
    "ARCS-Admins" = [
      { access = "manage all-resources", compartment = "ARCS" }
    ]
  }
}

# End of File