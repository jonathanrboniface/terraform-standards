#################################################################
# Snapshots
#################################################################
resource "google_compute_resource_policy" "vm" {
  name   = local.standardized_snapshot_schedule
  region = var.region

  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = var.snapshots_hourly_schedule
        start_time     = var.snapshots_start_time
      }
    }

    retention_policy {
      max_retention_days    = var.snapshots_max_retention_days
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }

    snapshot_properties {
      labels = merge(var.labels, {
        resource = "google-compute-resource-policy-snapshot-properties",
        location = var.region
      })
      storage_locations = ["us"]
      guest_flush       = false
    }
  }
}

resource "google_compute_resource_policy" "vm_vss" {
  name   = local.standardized_snapshot_schedule_vss
  region = var.region

  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = var.snapshots_hourly_schedule
        start_time     = var.snapshots_start_time
      }
    }

    retention_policy {
      max_retention_days    = var.snapshots_max_retention_days
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }

    snapshot_properties {
      labels = merge(var.labels, {
        resource = "google-compute-resource-policy-snapshot-properties",
        location = var.region
      })
      storage_locations = ["us"]
      guest_flush       = true
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "vm-attached" {
  count = length(var.attached_disks) == 0 ? 0 : length(google_compute_disk.vm)
  name  = google_compute_disk.vm[count.index].labels["vss"] ? google_compute_resource_policy.vm_vss.name : google_compute_resource_policy.vm.name
  disk  = google_compute_disk.vm[count.index].name
  zone  = google_compute_disk.vm[count.index].zone
}

resource "google_compute_disk_resource_policy_attachment" "vm-boot" {
  count = length(google_compute_instance.vm)
  name  = var.boot_disk[0].vss ? google_compute_resource_policy.vm_vss.name : google_compute_resource_policy.vm.name
  disk  = google_compute_instance.vm[count.index].name
  zone  = google_compute_instance.vm[count.index].zone
}
