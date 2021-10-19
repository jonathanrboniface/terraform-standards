variable "bucket_properties" {
  description = "Bucket properties containing required items to create one or muliptle buckets"
  type        = list(any)
  default     = []
}

variable "project" {
  type        = string
  description = "The project indicates the default GCP project all of your resources will be created in."
}

variable "project_number" {
  type        = number
  description = "The project number indicates the default GCP project number all of your resources will be created in."
}

variable "env" {
  type        = string
  description = "The environment being deployed into"
}

variable "region" {
  type        = string
  description = "The region will be used to choose the default location for regional resources. Regional resources are spread across several zones."
}

variable "description" {
  type        = string
  description = "used to describe resource, should be kept short as its used in the naming convention.  Max of 20 chars"
}

variable "org" {
  type        = string
  description = "name of organization, used for naming resources"
}

variable "kms_keys" {
  type        = map(string)
  description = "A list of all kms keys created via the kms module"
}
