#################################################################
# Locals
#################################################################
locals {
  name               = "${var.env}-${var.name}"
  nat_resource_count = var.enable_nat ? 1 : 0

  location_map = {
    europe-west2 = "euwe2",
    us-east1     = "usea1",
    us-east4     = "usea4",
  }

  org                          = substr(var.org, 0, 5)
  project                      = substr((split("-", var.project)[1]), 0, 10)
  location                     = substr(lookup(local.location_map, var.region), 0, 6)
  description                  = substr(var.description, 0, 20)
  env                          = substr(var.env, 0, 4)
  uid                          = "3d8f"
  standarized                  = "${local.org}-${local.project}-${local.env}-XXX-${local.location}-YYY-${local.uid}"
  standardized_network         = replace(replace(local.standarized, "XXX", "cne"), "YYY", local.description)
  standardized_subnet          = replace(local.standarized, "XXX", "csu")
  standardized_router          = replace(replace(local.standarized, "XXX", "crt"), "YYY", "router${local.description}")
  standardized_router_nat      = replace(replace(local.standarized, "XXX", "crn"), "YYY", "natgateway${local.description}")
  standardized_network_peering = replace(local.standarized, "XXX", "cnp")
  network_peering_exception = [
    "projects/tec-manage-prod-028e/global/networks/tec-manage-prod-cne-euwe2-management-3d8f",
    "projects/tec-manage-prod-028e/global/networks/tec-manage-prod-cne-euwe2-public-3d8f"
  ]
  standardized_subnets = flatten([
    for subnet in var.subnets : [
      "${local.org}-${local.project}-${local.env}-csu-${local.location}-${subnet["name"]}-${local.uid}"
    ]
  ])
  standardized_external_ip = replace(local.standarized, "XXX", "eip")
  nat_ips = flatten([
    for v in range(0, var.nat_additional_ips) : [
      [google_compute_address.nat_static_ip_additional[v].self_link]
    ]
  ])
}
