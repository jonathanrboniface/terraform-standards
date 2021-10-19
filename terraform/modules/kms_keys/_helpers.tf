#################################################################
# Data Resources
#################################################################
data "google_kms_key_ring" "key_ring" {
  count    = var.create_kms_key_ring ? 0 : 1
  name     = local.standardized_kms_keyring
  location = var.region
}

#################################################################
# Locals
#################################################################
locals {
  location_map = {
    europe-west2 = "euwe2",
    us-east1     = "usea1",
    us-east4     = "usea4",
  }
  description              = "kms"
  org                      = substr(var.org, 0, 5)
  project                  = substr((split("-", var.project)[1]), 0, 10)
  env                      = substr(var.env, 0, 4)
  location                 = substr(lookup(local.location_map, var.region), 0, 6)
  uuid                     = "3d8f"
  standardized             = "${local.org}-${local.project}-${local.env}-XXX-${local.location}-${local.description}-${local.uuid}"
  standardized_kms_keyring = replace(local.standardized, "XXX", "kyr")
  standardized_kms_key     = "${local.org}-${local.project}-${local.env}-kky-${local.location}-YYY-${local.uuid}"
}
