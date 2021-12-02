###################################
# Global variables
###################################
variable "env" {
  type        = string
  description = "The environment being deployed into"
}

variable "project" {
  type        = string
  description = "The project indicates the default GCP project all of your resources will be created in."
}

variable "project_number" {
  type        = number
  description = "The project number indicates the default GCP project number all of your resources will be created in."
}

variable "region" {
  type        = string
  description = "The region will be used to choose the default location for regional resources. Regional resources are spread across several zones."
}

###################################
variable "network" {
  type        = string
  description = "The name of the network used for this module."
}

variable "network_id" {
  type        = string
  description = "The id of the network used for this module."
}

variable "subnets" {
  type        = list(any)
  description = "The name of the subnetwork to put this instance(s) in. The subnetwork must exist in the same region this instance will be created in"
}

variable "private_ips" {
  type = list(any)
}

variable "alias_cidrs" {
  type        = list(any)
  description = "The name of the alias cidr to put this instance(s) in. The alias cidr must be part of the subet range"
  default     = []
}

variable "org" {
  type        = string
  description = "name of organization, used for naming resources"
}

variable "description" {
  type        = string
  description = "Used to describe resource, should be kept short as its used in the naming convention.  Max of 20 chars"
}

variable "machine_type" {
  type        = string
  description = "The machine type to create. Custom machine types can be formatted as custom-NUMBER_OF_CPUS-AMOUNT_OF_MEMORY_MB, e.g. custom-6-20480 for 6 vCPU and 20GB of RAM"
}

variable "metadata" {
  type        = map(string)
  description = "Metadata key/value pairs to make available from within the instance"
  default     = null
}

variable "name" {
  type        = string
  description = "A name for the resources in the instance group. Will pre prepended with the environment"
}

variable "num_instances" {
  type        = string
  description = "The number of instances to create"
  default     = 1
}

variable "network_tags" {
  type        = list(string)
  description = "A list of network tags to attach to the instance(s)."
}

variable "on_host_maintenance" {
  type        = string
  description = "Defines the maintenance behavior for the instances in the group"
  default     = "MIGRATE"
}

variable "service_account_scopes" {
  type        = list(string)
  description = ""
  default = [
    "compute-ro",
    "storage-ro",
    "logging-write",
    "monitoring",
    # NOTE: trace wasn't resolving to url name, so I used full version
    "https://www.googleapis.com/auth/trace.append",
    "cloud-platform"
  ]
}

variable "zones" {
  description = "GCP zone to deploy the resources in"
  type        = list(any)
}

variable "labels" {
  type        = map(string)
  description = " A map of key/value label pairs to assign to the instance."
}

variable "instance_description" {
  type        = string
  description = "A description to give the instances in the instance group"
}

variable "shielded_vm" {
  description = "true/false on if shielded vm features are enabled"
  default     = true
}

variable "disks" {
  type        = list(any)
  default     = []
  description = "List of Map that have details about each disk to attach, first drive attached is the boot disk"
}

variable "boot_disk" {
  type        = list(any)
  description = "List of Map that have details about each disk to attach, first drive attached is the boot disk"
}

variable "attached_disks" {
  type        = list(any)
  default     = []
  description = "List of Map that have details about each disk to attach, first drive attached is the boot disk"
}

variable "snapshots_hourly_schedule" {
  description = "The boolean value to determine if an hourly snapshot schedule should be created"
  type        = bool
  default     = false
}

variable "snapshot_schedule" {
  description = "The values for each of the daily and hourly snapshots and retention policies"
  type        = list(any)
}

variable "external_ip" {
  type        = string
  description = "Whether to assign an external ip"
  default     = false
}

variable "sole_tenancy" {
  description = "Whether to put the MIG on sole tenant nodes"
  default     = false
}

variable "windows_startup_script" {
  type        = string
  description = "The contents of the windows startup script"
}

variable "enable_vss" {
  description = "The boolean value determining if VSS (Volume Shadow Snapshots) should be enabled or not. Default to 'false'"
  type        = bool
  default     = false
}

#####################################################
# Firewall
#####################################################
variable "firewall_rules" {
  description = "Firewall rules containing protocol and port list"
  type        = list(any)
  default     = []
}

variable "connectivity_tests" {
  description = "connectivity_tests"
  type        = list(any)
  default     = []
}

variable "kms_key" {
  type        = string
  description = "kms keys created for the vm instance includes this value as a part of its key name. preferably have both description and key_name vars same value for an instance"
  default     = ""
}

variable "kms_key_self_link" {
  type = string
}

#####################################################
# vm_schedule
#####################################################
variable "vm_schedule_start" {
  type        = string
  description = "Schedule for starting instance, using the unix-cron format."
  default     = ""
}
variable "vm_schedule_stop" {
  type        = string
  description = "Schedule for stopping instance, using the unix-cron format."
  default     = ""
}
variable "vm_schedule_tz" {
  type        = string
  description = "The time zone to be used in interpreting the schedule"
  default     = "UTC"
}
