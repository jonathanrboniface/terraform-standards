#################################################################
# Locals
#################################################################
locals {
  location_map = {
    europe-west2 = "euwe2",
    us-east1     = "usea1",
    us-east4     = "usea4",
  }
  org                  = substr(var.org, 0, 5)
  project              = substr((split("-", var.project)[1]), 0, 10)
  location             = substr(lookup(local.location_map, var.region), 0, 6)
  uid                  = "3d8f"
  env                  = substr(var.env, 0, 4)
  standarized_dns_zone = "${local.org}-${local.project}-${local.env}-dns-${local.location}-YYY-${local.uid}"
  dns_zones_flattened = flatten([
    for id in range(length(var.dns_zones)) : {
      type       = var.dns_zones[id].type
      name       = replace(local.standarized_dns_zone, "YYY", "${var.dns_zones[id].type == "forwarding" ? "fwd" : ""}${replace(replace(var.dns_zones[id].dns_zone, ".", ""), "-", "")}")
      dns_zone   = var.dns_zones[id].dns_zone
      visibility = var.dns_zones[id].visibility
    }
  ])
  dns_records_flattened = flatten([
    for id in range(length(var.dns_records)) : {
      name     = var.dns_records[id].name
      dns_zone = replace(local.standarized_dns_zone, "YYY", "${var.dns_records[id].type == "forwarding" ? "fwd" : ""}${replace(replace(var.dns_records[id].dns_zone, ".", ""), "-", "")}")
      type     = var.dns_records[id].type
      ttl      = var.dns_records[id].ttl
      rrdatas  = [var.dns_records[id].rrdatas]
    }
  ])
}
