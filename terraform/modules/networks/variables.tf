variable "project" {
  type        = string
  description = "The project indicates the default GCP project all of your resources will be created in."
}

variable "region" {
  type        = string
  description = "The region will be used to choose the default location for regional resources. Regional resources are spread across several zones."
}

variable "stack" {
  type        = string
  description = "Used in naming resources, see locals"
  default     = "net"
}

variable "env" {
  type        = string
  description = "The environment being deployed"
}

variable "name" {
  type        = string
  description = "The name of the  vpc"
}

variable "description" {
  type        = string
  description = "The description of the  vpc"
}

variable "enable_nat" {
  type        = string
  description = "True to setup nat for outbound traffic on the VPC"
}

variable "peer_to_vpcs" {
  type        = list(map(string))
  description = "List of vpc ids we want to peer this network to."
  default     = []
}

variable "subnets" {
  type        = list(map(string))
  description = "List of subnets to add to this network"
}

variable "org" {
  type        = string
  description = "Org name used in naming resources, see locals"
}

variable "nat_ip_enable_static" {
  type        = bool
  description = "Determines whether the NAT Gateway should use a static IP Address or a dynamic address assigned by GCP. Defaults to true."
  default     = true
}

variable "nat_additional_ips" {
  type        = number
  description = "Determines the number of additional cloud nat ip addresses to be created. Defaults to 0."
  default     = 0
}

variable "nat_min_ports_per_vm" {
  type        = number
  description = "Determines the minium number of ports per vm in the cloud nat configuration. Defaults to 1024."
  default     = 1024
}
