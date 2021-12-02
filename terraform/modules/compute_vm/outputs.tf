output "instance_names" {
  value       = [for vm in google_compute_instance.vm : vm.name]
  description = "The name(s) of the compute engine instances"
}

output "disks" {
  value = {
    for vm_disk in google_compute_disk.vm :
    vm_disk.id => vm_disk.name
  }
  description = "A list of attached disks"
}

output "snapshot_schedule" {
  value = {
    for vm_snapshot in google_compute_resource_policy.vm :
    vm_snapshot.id => vm_snapshot.snapshot_schedule_policy.*.schedule
    if var.snapshots_hourly_schedule == false
  }
  description = "snapshot schedule for compute disks"
}

output "vm_schedule" {
  value = {
    for instance_schedule_policy in google_compute_resource_policy.vm_schedule :
    instance_schedule_policy.id => instance_schedule_policy.instance_schedule_policy
  }
  description = "instance schedule for start and stop"
}

output "retention_policy" {
  value = {
    for snapshot_schedule_policy in google_compute_resource_policy.vm :
    snapshot_schedule_policy.id => snapshot_schedule_policy.snapshot_schedule_policy.*.retention_policy
    if var.snapshots_hourly_schedule == false
  }
  description = "retention policy for compute disks"
}
