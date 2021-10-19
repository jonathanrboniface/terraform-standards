#################################################################
# Data Resources
#################################################################
# GCS Cloud Setup
#
data "terraform_remote_state" "vpc_peers" {
  backend  = "gcs"
  for_each = { for k, v in var.env_peers : k => v }
  config = {
    bucket = lookup(each.value, "bucket", [])
    prefix = lookup(each.value, "env", [])
  }
}

# Terraform Cloud Setup
#
# data "terraform_remote_state" "vpc_peers" {
#   backend  = "remote"
#   for_each = { for k, v in var.env_peers : k => v }
#   config = {
#     organization = "exigertech"
#     workspaces = {
#       name = lookup(each.value, "env", [])
#     }
#   }
# }


#################################################################
# Locals
#################################################################
locals {
  # peer_to_vpcs = flatten(toset([for k, v in var.env_peers : [
  #   for network in v.networks : {
  #     id            = data.terraform_remote_state.vpc_peers[k].outputs.vpc[network.network].id,
  #     name          = network.name
  #     export_routes = network.export_routes
  #     import_routes = network.import_routes
  #   }]
  # ]))
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
  standarized              = "${local.org}-${local.project}-${local.env}-XXX-${local.location}-${local.description}-${local.uuid}"
  standardized_kms_keyring = replace(local.standarized, "XXX", "kyr")
  standardized_kms_key     = "${local.org}-${local.project}-${local.env}-kky-${local.location}-YYY-${local.uuid}"
}
