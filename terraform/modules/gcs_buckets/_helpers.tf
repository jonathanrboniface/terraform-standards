locals {
  location_map = {
    europe-west2 = "euwe2",
    us-east1     = "usea1",
    us-east4     = "usea4",
  }
  org                  = substr(var.org, 0, 5)
  project              = substr((split("-", var.project)[1]), 0, 10)
  env                  = substr(var.env, 0, 4)
  location             = substr(lookup(local.location_map, var.region), 0, 6)
  description          = substr(var.description, 0, 20)
  uuid                 = "3d8f"
  standardized         = "${local.org}-${local.project}-${local.env}-XXX-${local.location}-${local.description}-${local.uuid}"
  standardized_bucket  = "${local.org}-${local.project}-${local.env}-XXX"
  standardized_kms_key = "${local.org}-${local.project}-${local.env}-kky-${local.location}-YYY-${local.uuid}"
}
