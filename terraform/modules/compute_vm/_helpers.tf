#################################################################
# Locals
#################################################################
locals {
  location_map = {
    europe-west2 = "euwe2",
    us-east1     = "usea1",
    us-east4     = "usea4",
  }
  oscheck                            = regexall("windows", local.boot_disk)
  boot_disk                          = length(var.boot_disk) > 0 ? var.boot_disk[0]["source_image"] : ""
  org                                = substr(var.org, 0, 5)
  project                            = substr((split("-", var.project)[1]), 0, 10)
  location                           = substr(lookup(local.location_map, var.region), 0, 6)
  description                        = substr(var.description, 0, 20)
  env                                = substr(var.env, 0, 4)
  kms_key                            = var.kms_key == "" ? substr(var.kms_key, 0, 20) : var.description
  standardized                       = "${local.org}-${local.project}-${local.env}-XXX-${local.location}-${local.description}-${local.uuid}"
  standardized_compute_instance      = replace(local.standardized, "XXX", "cvm")
  standardized_snapshot_schedule     = replace(local.standardized, "XXX", "snp")
  standardized_snapshot_schedule_vss = replace(local.standardized_snapshot_schedule, local.description, "${local.description}vss")
  standarized_connectivity_test      = "${local.org}-${local.project}-${local.env}-nct-${local.location}-YYY-${local.uuid}"
  name_prefix                        = local.standardized_compute_instance
  name_ids                           = range(1, var.num_instances + 1)

  disks_flattened = flatten([
    for name_id in local.name_ids : [
      for disk in var.attached_disks : {
        vm_id        = name_id,
        name         = disk.name,
        disk_size_gb = disk.disk_size_gb,
        disk_type    = disk.disk_type,
        source_image = disk.source_image,
        vss          = disk.vss != false ? disk.vss : false
        zone         = element(var.zones, (name_id - 1))
      }
    ]
  ])
  uuid                  = "3d8f"
  standardized_firewall = replace("${local.org}-${local.project}-${local.env}-XXX-${local.location}-YYY-${local.uuid}", "XXX", "cfw")
}
