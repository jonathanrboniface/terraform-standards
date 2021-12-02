
#################################################################
# vm_schedule
#################################################################
resource "google_compute_resource_policy" "vm_schedule" {
  count       = length(var.vm_schedule_start) == 0 || length(var.vm_schedule_stop) == 0 ? 0 : 1
  name        = local.vm_schedule_policy
  region      = var.region
  description = "Start and stop instances"
  instance_schedule_policy {
    vm_start_schedule {
      schedule = var.vm_schedule_start
    }
    vm_stop_schedule {
      schedule = var.vm_schedule_stop
    }
    time_zone = var.vm_schedule_tz
  }
}
