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
  }]
}

###################################
# GKE Variables
###################################

variable "gke_version" {
  type        = string
  description = "Min version of GKE, used for both masters and work nodes"
  default     = "1.20.9-gke.1001"
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
  default     = 3
}


variable "max_node_count" {
  type        = string
  description = "Maximum number of nodes in the NodePool. Must be >= min_node_count."
  default     = 5
}

variable "min_node_count" {
  type        = string
  description = "Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count."
  default     = 3
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
