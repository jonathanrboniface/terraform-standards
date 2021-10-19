variable "env" {
  type        = string
  description = "The environment being deployed into"
}

variable "project" {
  type        = string
  description = "The project indicates the default GCP project all of your resources will be created in."
}

variable "rotation_period" {
  type        = string
  description = "Key rotation period in seconds"
  default     = "100000s"
}

variable "keys" {
  type        = list(any)
  description = "List of encryption keys to be created. Example: [{component='app'},{component='db'}] . component value should match the mig/compute-vm description"
}

## set this variable to true when existing KMS key ring in a project is to be used
variable "create_kms_key_ring" {
  type        = bool
  description = "boolean flag to determine whether to create kms key ring or not"
  default     = true
}

variable "region" {
  type        = string
  description = "The region will be used to choose the default location for regional resources. Regional resources are spread across several zones."
}

variable "org" {
  type        = string
  description = "name of organization, used for naming resources"
}
