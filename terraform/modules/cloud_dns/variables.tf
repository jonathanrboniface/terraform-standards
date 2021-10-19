variable "env" {
  type        = string
  description = "The environment to deploy the module in"
}

variable "project" {
  type        = string
  description = "The project to deploy the module in"
}

variable "org" {
  type        = string
  description = "Org name used in naming resources, see locals"
}

variable "region" {
  type        = string
  description = "The region will be used to choose the default location for regional resources. Regional resources are spread across several zones."
}


variable "dns_zones" {
  type        = list(map(string))
  description = " A map of key/value label pairs to assign to the dns zones."
}

variable "dns_records" {
  type        = list(map(string))
  description = " A map of key/value label pairs to create a dns record in a zone."
}

variable "networks_visibility_peering" {
  type        = list(string)
  description = "The subnets to use the dns peering"
  default     = []
}

variable "networks_visibility_forwarding" {
  type        = list(string)
  description = "The subnets to use the dns forwarding"
  default     = []
}

variable "network_peers" {
  type        = list(string)
  description = "The subnets to peers to"
  default     = []
}

variable "target_dns_servers" {
  type        = list(string)
  description = "List of target DNS servers for the forwarding zones"
  default     = []
}

variable "private_forwarding_path" {
  type        = bool
  description = "List of target DNS servers for the forwarding zones"
  default     = false
}
