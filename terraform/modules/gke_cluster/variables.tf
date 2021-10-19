variable "additional_oath_scopes" {
  type        = list(string)
  description = "Additional set of Google API scopes to be made available on all of the node VMs under the default service account. These can be either FQDNs, or scope aliases."
  default     = []
}

variable "authorized_cidrs" {
  type        = list(map(string))
  description = "A list of maps of cidr blocks to allow access to the cluster. ="
}

variable "cluster_ipv4_cidr_block" {
  type        = string
  description = "The IP address range for the cluster pod IPs. Set to blank to have a range chosen with the default size. Set to /netmask (e.g. /14) to have a range chosen with a specific netmask. Set to a CIDR notation (e.g. 10.96.0.0/14) from the RFC-1918 private networks (e.g. 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) to pick a specific range to use."
  default     = "/16"
}

variable "description" {
  type        = string
  description = "Used to describe resource, should be kept short as its used in the naming convention.  Max of 20 chars"
}

variable "env" {
  type        = string
  description = "The environment being deployed into"
}

variable "initial_node_count" {
  type        = string
  description = "The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource."
}

variable "logging_service" {
  type        = string
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com(Legacy Stackdriver), logging.googleapis.com/kubernetes(Stackdriver Kubernetes Engine Logging), and none."
  default     = "logging.googleapis.com/kubernetes"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network. This range will be used for assigning private IP addresses to the cluster master(s) and the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network, and it must be a /28 subnet.This field only applies to private clusters, when private_cluster is true."
  default     = "172.16.0.32/28"
}

variable "min_master_version" {
  type        = string
  description = "The minimum version of the master. GKE will auto-update the master to new versions, so this does not guarantee the current master version"
}

variable "max_node_count" {
  type        = string
  description = "Maximum number of nodes in the NodePool. Must be >= min_node_count."
}

variable "min_node_count" {
  type        = string
  description = "Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count."
}

variable "monitoring_service" {
  type        = string
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com(Legacy Stackdriver), monitoring.googleapis.com/kubernetes(Stackdriver Kubernetes Engine Monitoring), and none"
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "network" {
  type        = string
  description = "The name of the Google Compute Engine network in which the cluster's instances are launched. "
}

variable "node_auto_repair" {
  type        = string
  description = "Whether the nodes will be automatically repaired."
  default     = true
}

variable "node_auto_upgrade" {
  type        = string
  description = "Whether the nodes will be automatically upgraded."
  default     = true
}

variable "node_machine_type" {
  type        = string
  description = "The name of a Google Compute Engine machine type. Defaults to e2-medium"
  default     = "e2-medium"
}

variable "node_preemptible" {
  type        = string
  description = "True to use preemptible nodes. defaults to False"
  default     = false
}

variable "private_cluster" {
  type        = string
  description = "True to create a private GKE cluster"
  default     = true
}

variable "private_endpoint" {
  type        = string
  description = "When true, the cluster's private endpoint is used as the cluster endpoint and access through the public endpoint is disabled. When false, either endpoint can be used. This field only applies to private clusters, when private_cluster is true"
  default     = true
}

variable "project" {
  type        = string
  description = "The project indicates the default GCP project all of your resources will be created in."
}

variable "region" {
  type        = string
  description = "The region will be used to choose the default location for regional resources. Regional resources are spread across several zones."
}

variable "services_ipv4_cidr_block" {
  type        = string
  description = "The IP address range of the services IPs in this cluster. Set to blank to have a range chosen with the default size. Set to /netmask (e.g. /14) to have a range chosen with a specific netmask. Set to a CIDR notation (e.g. 10.96.0.0/14) from the RFC-1918 private networks (e.g. 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) to pick a specific range to use."
  default     = "/22"
}

variable "org" {
  type        = string
  description = "name of organization, used for naming resources"
}

variable "subnet" {
  type        = string
  description = "The name of the Google Compute Engine subnetwork in which the cluster's instances are launched. "
}

variable "enable_shielded_nodes" {
  type        = string
  description = "The GKE control plane cryptographically verifies that every node in the cluster is a virtual machine running in a managed instance group in Google’s data center and that the kubelet is only getting the certificate for itself."
  default     = true
}

variable "boot_disk_kms_key" {
  type        = string
  description = "kms key self link"
}
