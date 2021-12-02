###################################
# Global variables
###################################
variable "env" {
  type        = string
  description = "The environment being deployed into"
  default     = "endor"
}

variable "project" {
  type        = string
  description = "The project indicates the default GCP project all of your resources will be created in."
  default     = "endor-327818"
}

variable "project_number" {
  type        = number
  description = "The project number indicates the default GCP project number all of your resources will be created in."
  default     = "270897410629"
}

variable "region" {
  type        = string
  description = "The region will be used to choose the default location for regional resources. Regional resources are spread across several zones."
  default     = "europe-west2"
}

variable "zones" {
  type        = list(any)
  description = "The list of zones that will be used for the resources."
  default     = ["europe-west2-a"]
}

variable "remote_state_bucket" {
  type        = string
  description = "name of the bucket from which terraform remote state is retrieved"
  default     = "tf-state-stroage"
}

variable "project_group" {
  type        = string
  description = "The project indicates the default GCP project all of your resources will be created in."
  default     = "test"
}

variable "network_prefix" {
  type        = string
  description = "Used in naming resources, see locals"
  default     = "endor"
}

variable "org" {
  type        = string
  description = "name of organization, used for naming resources"
  default     = "endor"
}

variable "ssl_certificate" {
  type        = string
  description = "The value of the SSL Certificate defined in Terraform Cloud"
  default     = ""
}

variable "ssl_private_key" {
  type        = string
  description = "The value of the SSL Certificate Key defined in Terraform Cloud or locally"
  default     = ""
}

###################################
# Network variables
###################################

variable "vpc_private_name" {
  type        = string
  description = "The name of the private vpc"
  default     = ""
}

variable "vpc_private_description" {
  type        = string
  description = "The description of the private vpc"
  default     = ""
}

variable "vpc_private_enable_nat" {
  type        = string
  description = "True to setup nat for outbound traffic on the public VPC"
  default     = false
}

variable "vpc_private_subnets" {
  type        = list(map(string))
  description = "List of maps holding info about subnets needed in the management vpc"
  default = [
    { name : "app", cidr : "10.202.26.0/24" },
    { name : "db", cidr : "10.202.27.0/24" },
  ]
}

variable "env_peers" {
  type = map(object({
    env      = string,
    bucket   = string,
    networks = list(map(string)),
  }))
  default = {
    endorapp = {
      env    = "endor-327818",
      bucket = "tf-state-stroage",
      networks = [
        { network = "app", name = "endorapp", export_routes = false, import_routes = false },
        { network = "db", name = "endordb", export_routes = false, import_routes = false },
      ],
    },
  }
}

variable "cloud_nat_ip_enable_static" {
  type        = bool
  description = "Determines whether the NAT Gateway should use a static IP Address or a dynamic address assigned by GCP. Defaults to true."
  default     = true
}

variable "cloud_nat_additional_ips" {
  type        = number
  description = "Determines the number of additional cloud nat ip addresses to be created. Defaults to 0."
  default     = 0
}

variable "cloud_nat_min_ports_per_vm" {
  type        = number
  description = "Determines the minium number of ports per vm in the cloud nat configuration. Must be a multiple of 2. Defaults to 1024."
  default     = 1024
}

###################################
# KMS variables
###################################
variable "kms_keys" {
  type        = list(any)
  description = "List of KMS keys to be created"
  default = [
    {
      stack     = "gke_cluster"
      component = "elk"
    },
    {
      stack     = "gcs_bucket"
      component = "buckets"
    }
  ]
}

###################################
# Cloud DNS variables
###################################
variable "dns_zones" {
  type        = list(map(string))
  description = " A map of key/value label pairs to assign to the dns zones."
  default     = []
}

variable "dns_records" {
  type        = list(map(string))
  description = " A map of key/value label pairs to create a dns record in a desired zone."
  default     = []
}


###################################
# Bucket variables
###################################
variable "bucket_properties" {
  description = "GCP bucket properties"
  type        = list(any)
  default = [{
    name                        = "buckets"
    storage_class               = "STANDARD"
    force_destroy               = false
    uniform_bucket_level_access = true
    versioning_enabled          = true
    retention_policy            = []
    lifecycle_rules             = []
    service_account_create      = true
    service_account_name        = "buckets"
    service_account_desc        = ""
    kms_key                     = "endor-327818-endo-kky-euwe2-buckets-3d8f"
    },
    {
      name                        = "bridgecrew"
      storage_class               = "STANDARD"
      force_destroy               = false
      uniform_bucket_level_access = false
      versioning_enabled          = false
      retention_policy            = []
      lifecycle_rules             = []
      service_account_create      = true
      service_account_name        = "bridgecrew-test"
      service_account_desc        = ""
      kms_key                     = "endor-327818-endo-kky-euwe2-buckets-3d8f"
  }]
}

###################################
# GKE Variables
###################################

variable "gke_version" {
  type        = string
  description = "Min version of GKE, used for both masters and work nodes"
  default     = "1.21.5-gke.1302"
}

variable "create_gke_cluster" {
  type        = bool
  description = "flag to determine whether to create gke cluster or not"
  default     = false
}

variable "node_machine_type" {
  type        = string
  description = "The name of a Google Compute Engine machine type. Defaults to e2-medium"
  default     = "e2-standard-4"
}

variable "initial_node_count" {
  type        = string
  description = "The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource."
  default     = 2
}

variable "max_node_count" {
  type        = string
  description = "Maximum number of nodes in the NodePool. Must be >= min_node_count."
  default     = 4
}

variable "min_node_count" {
  type        = string
  description = "Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count."
  default     = 2
}

variable "gke_worker_node_boot_disk_kms_key" {
  type        = string
  description = "Name of the KMS key component used for encrypting boot disk of GKE worker nodes. Remember this value is not a KMS self link. Actual Self link value is constructed here"
  default     = "elk"
}

variable "run_windows_startup_script" {
  type        = bool
  description = "Whether to run the windows startup script"
  default     = false
}



###################################
# VM Variables
###################################

variable "create_servers_instances" {
  type        = number
  description = "flag to determine whether to create VM instances or not"
  default     = 0
}

variable "vm_instances" {
  type        = number
  description = "flag to determine whether to create VM instances or not"
  default     = 0
}

variable "vm_servers_kms_key" {
  type        = string
  description = "Name of the KMS key component used for encrypting boot disk of GKE worker nodes. Remember this value is not a KMS self link. Actual Self link value is constructed here"
  default     = "elk"
}

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

variable "snapshots_hourly_schedule" {
  description = "The boolean value to determine if an hourly snapshot schedule should be created"
  type        = bool
  default     = false
}

variable "snapshots_schedule" {
  description = "The values for each of the daily and hourly snapshots and retention policies"
  type        = list(any)
  default = [
    {
      hourly_schedule = [{
        hours_in_cycle = 1,
        start_time     = "00:00",
      }],
      hourly_retention_policy = [{
        max_retention_days    = 7,
        on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
      }],
      daily_schedule = [{
        days_in_cycle = 1,
        start_time    = "00:00",
      }],
      daily_retention_policy = [{
        max_retention_days    = 7,
        on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
      }]
    },
  ]
}

variable "private_ips" {
  type        = list(any)
  description = "The private_ips to use for the microservices DB servers"
  default     = []
}

variable "network_tags" {
  type        = list(string)
  description = "A list of network tags to attach to the servers."
  default     = ["vms"]
}

variable "boot_disks" {
  type        = list(any)
  description = "List of Map that have details about the boot disk fir the microservices DB servers"
  default = [
    { name         = "boot"
      disk_size_gb = 100
      disk_type    = "pd-ssd"
      source_image = "windows-2016"
      vss          = false
  }]
}

variable "attached_disks" {
  type        = list(any)
  description = "List of Map that have details about attached drives for the microservices DB servers"
  default = [
    {
      name         = "data"
      disk_size_gb = 100
      disk_type    = "pd-ssd"
      source_image = null
      vss          = false
    },
  ]
}

variable "labels" {
  type        = map(string)
  description = " A map of key/value label pairs to assign to the instance."
  default     = { component : "vms" }
}

variable "machine_type" {
  type        = string
  description = "The machine type to create for the jump servers. Custom machine types can be formatted as custom-NUMBER_OF_CPUS-AMOUNT_OF_MEMORY_MB, e.g. custom-6-20480 for 6 vCPU and 20GB of RAM"
  default     = "e2-standard-2"
}

variable "enable_vss" {
  description = "The boolean value determining if VSS (Volume Shadow Snapshots) should be enabled or not. Default to 'false'"
  type        = bool
  default     = false
}
