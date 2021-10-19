#################################################################
# Locals
#################################################################
locals {
  location_map = {
    europe-west2 = "euwe2",
    us-east4     = "usea4",
  }

  manditory_oauth_scopes = [
    "compute-rw",
    "storage-rw",
    "logging-write",
    "monitoring",
  ]

  oauth_scopes             = compact(concat(local.manditory_oauth_scopes, var.additional_oath_scopes))
  uid                      = "3d8f"
  org                      = substr(var.org, 0, 5)
  project                  = substr((split("-", var.project)[1]), 0, 10)
  location                 = substr(lookup(local.location_map, var.region), 0, 6)
  description              = substr(var.description, 0, 20)
  env                      = substr(var.env, 0, 4)
  standardized             = "${local.org}-${local.project}-${local.env}-XXX-${local.location}-${local.description}-${local.uid}"
  standardized_gke_cluster = replace(local.standardized, "XXX", "gke")
}
