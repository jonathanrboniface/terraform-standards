#################################################################
# Snapshots
#################################################################
resource "google_compute_resource_policy" "vm" {

  for_each = toset(keys({ for k, v in var.snapshot_schedule : k => v if var.snapshots_hourly_schedule == false }))
  name     = local.standardized_snapshot_schedule
  region   = var.region

  snapshot_schedule_policy {

    dynamic "schedule" {
      for_each = var.snapshot_schedule[each.value]["daily_schedule"]
      content {
        daily_schedule {
          days_in_cycle = schedule.value.days_in_cycle
          start_time    = schedule.value.start_time
        }
      }
    }

    dynamic "retention_policy" {
      for_each = var.snapshot_schedule[each.value]["daily_retention_policy"]
      content {
        max_retention_days    = retention_policy.value.max_retention_days
        on_source_disk_delete = retention_policy.value.on_source_disk_delete
      }
    }

    snapshot_properties {
      labels = merge(var.labels, {
        resource = "google-compute-resource-policy-snapshot-properties",
        location = var.region
      })
      storage_locations = ["eu"]
      guest_flush       = var.enable_vss
    }
  }
}

resource "google_compute_resource_policy" "vm_hourly" {

  for_each = toset(keys({ for k, v in var.snapshot_schedule : k => v if var.snapshots_hourly_schedule == true }))
  name     = "${local.standardized_snapshot_schedule}-hourly"
  region   = var.region

  snapshot_schedule_policy {

    dynamic "schedule" {
      for_each = var.snapshot_schedule[each.value]["hourly_schedule"]
      content {
        hourly_schedule {
          hours_in_cycle = schedule.value.hours_in_cycle
          start_time     = schedule.value.start_time
        }
      }
    }

    dynamic "retention_policy" {
      for_each = var.snapshot_schedule[each.value]["hourly_retention_policy"]
      content {
        max_retention_days    = retention_policy.value.max_retention_days
        on_source_disk_delete = retention_policy.value.on_source_disk_delete
      }
    }

    snapshot_properties {
      labels = merge(var.labels, {
        resource = "google-compute-resource-policy-snapshot-properties",
        location = var.region
      })
      storage_locations = ["eu"]
      guest_flush       = var.enable_vss
    }
  }
}

resource "google_compute_resource_policy" "vm_vss" {
  for_each = toset(keys({ for k, v in var.snapshot_schedule : k => v if var.snapshots_hourly_schedule == false }))
  name     = local.standardized_snapshot_schedule_vss
  region   = var.region

  snapshot_schedule_policy {
    dynamic "schedule" {
      for_each = var.snapshot_schedule[each.value]["daily_schedule"]
      content {
        daily_schedule {
          days_in_cycle = schedule.value.days_in_cycle
          start_time    = schedule.value.start_time
        }
      }
    }

    dynamic "retention_policy" {
      for_each = var.snapshot_schedule[each.value]["daily_retention_policy"]
      content {
        max_retention_days    = retention_policy.value.max_retention_days
        on_source_disk_delete = retention_policy.value.on_source_disk_delete
      }
    }

    snapshot_properties {
      labels = merge(var.labels, {
        resource = "google-compute-resource-policy-snapshot-properties",
        location = var.region
      })
      storage_locations = ["eu"]
      guest_flush       = var.enable_vss
    }
  }
}

resource "google_compute_resource_policy" "vm_vss_hourly" {
  for_each = toset(keys({ for k, v in var.snapshot_schedule : k => v if var.snapshots_hourly_schedule == true }))
  name     = "${local.standardized_snapshot_schedule_vss}-hourly"
  region   = var.region

  snapshot_schedule_policy {
    dynamic "schedule" {
      for_each = var.snapshot_schedule[each.value]["hourly_schedule"]
      content {
        hourly_schedule {
          hours_in_cycle = schedule.value.hours_in_cycle
          start_time     = schedule.value.start_time
        }
      }
    }

    dynamic "retention_policy" {
      for_each = var.snapshot_schedule[each.value]["hourly_retention_policy"]
      content {
        max_retention_days    = retention_policy.value.max_retention_days
        on_source_disk_delete = retention_policy.value.on_source_disk_delete
      }
    }

    snapshot_properties {
      labels = merge(var.labels, {
        resource = "google-compute-resource-policy-snapshot-properties",
        location = var.region
      })
      storage_locations = ["eu"]
      guest_flush       = var.enable_vss
    }
  }
}


resource "google_compute_disk_resource_policy_attachment" "vm-attached" {
  depends_on = [
    google_compute_disk.vm, google_compute_resource_policy.vm, google_compute_resource_policy.vm_vss,
    google_compute_resource_policy.vm_hourly, google_compute_resource_policy.vm_vss_hourly
  ]
  for_each = { for k, v in local.disks_flattened : k => v if v.name != "boot" && var.snapshots_hourly_schedule == false }
  name     = each.value["vss"] ? local.standardized_snapshot_schedule_vss : local.standardized_snapshot_schedule
  disk     = "${local.standardized_compute_instance}-${each.value["vm_id"]}-${each.value["name"]}"
  zone     = each.value["zone"]
}

resource "google_compute_disk_resource_policy_attachment" "vm-boot" {
  depends_on = [
    google_compute_instance.vm, google_compute_resource_policy.vm, google_compute_resource_policy.vm_vss,
    google_compute_resource_policy.vm_hourly, google_compute_resource_policy.vm_vss_hourly
  ]
  for_each = { for k, v in local.boot_disks_flattened : k => v if v.name == "boot" && var.snapshots_hourly_schedule == false }
  name     = each.value["vss"] ? local.standardized_snapshot_schedule_vss : local.standardized_snapshot_schedule
  disk     = "${local.standardized_compute_instance}-${each.value["vm_id"]}"
  zone     = each.value["zone"]
}

resource "google_compute_disk_resource_policy_attachment" "vm-attached-hourly" {
  depends_on = [
    google_compute_disk.vm, google_compute_resource_policy.vm, google_compute_resource_policy.vm_vss,
    google_compute_resource_policy.vm_hourly, google_compute_resource_policy.vm_vss_hourly
  ]
  for_each = { for k, v in local.disks_flattened : k => v if v.name != "boot" && var.snapshots_hourly_schedule == true }
  name     = google_compute_disk.vm[each.key].labels["vss"] ? "${local.standardized_snapshot_schedule_vss}-hourly" : "${local.standardized_snapshot_schedule}-hourly"
  disk     = "${local.standardized_compute_instance}-${each.value["vm_id"]}-${each.value["name"]}"
  zone     = each.value["zone"]
}

resource "google_compute_disk_resource_policy_attachment" "mig-boot-hourly" {
  depends_on = [
    google_compute_instance.vm, google_compute_resource_policy.vm, google_compute_resource_policy.vm_vss,
    google_compute_resource_policy.vm_hourly, google_compute_resource_policy.vm_vss_hourly
  ]
  for_each = { for k, v in local.boot_disks_flattened : k => v if v.name == "boot" && var.snapshots_hourly_schedule == true }
  name     = each.value["vss"] ? "${local.standardized_snapshot_schedule_vss}-hourly" : "${local.standardized_snapshot_schedule}-hourly"
  disk     = "${local.standardized_compute_instance}-${each.value["vm_id"]}"
  zone     = each.value["zone"]
}
