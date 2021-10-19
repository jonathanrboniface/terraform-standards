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
  value       = [google_compute_resource_policy.vm.snapshot_schedule_policy.*.schedule]
  description = "snapshot schedule for compute disks"
}

output "retention_policy" {
  value       = [google_compute_resource_policy.vm.snapshot_schedule_policy.*.retention_policy]
  description = "retention policy for compute disks"
}
