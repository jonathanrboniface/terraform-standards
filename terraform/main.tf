/**
 * # Main title
 *
 * Everything in this comment block will get extracted.
 *
 * You can put simple text or complete Markdown content
 * here. Subsequently if you want to render AsciiDoc format
 * you can put AsciiDoc compatible content in this comment
 * block.
 */

module "network_private" {
  source = "./modules/networks"

  description          = var.vpc_private_description
  enable_nat           = var.vpc_private_enable_nat
  env                  = var.env
  org                  = var.org
  name                 = var.vpc_private_name
  project              = var.project
  region               = var.region
  subnets              = var.vpc_private_subnets
  nat_ip_enable_static = var.cloud_nat_ip_enable_static
  nat_additional_ips   = var.cloud_nat_additional_ips
  nat_min_ports_per_vm = var.cloud_nat_min_ports_per_vm
}

module "kms" {
  source  = "./modules/kms_keys"
  project = var.project
  env     = var.env
  keys    = var.kms_keys
  org     = var.org
  region  = var.region
}

module "cloud_dns" {
  source                      = "./modules/cloud_dns"
  project                     = var.project
  env                         = var.env
  dns_zones                   = var.dns_zones
  dns_records                 = var.dns_records
  org                         = var.org
  region                      = var.region
  networks_visibility_peering = [module.network_private.self_link]
  # network_peers               = [data.terraform_remote_state.common-prod.outputs.vpc_management.self_link]
}

module "gcs_bucket" {
  source            = "./modules/gcs_buckets"
  project           = var.project
  project_number    = var.project_number
  region            = var.region
  env               = var.env
  org               = var.org
  description       = "gcs"
  bucket_properties = var.bucket_properties
  kms_keys          = module.kms.kms_keys
}

module "gke" {
  depends_on = [module.kms]
  source     = "./modules/gke_cluster"

  count              = var.create_gke_cluster ? 1 : 0
  description        = "gke"
  env                = var.env
  org                = var.org
  initial_node_count = var.initial_node_count
  max_node_count     = var.max_node_count
  min_master_version = var.gke_version
  min_node_count     = var.min_node_count
  network            = module.network_private.name
  project            = var.project
  region             = var.region
  subnet             = module.network_private.subnets.app
  authorized_cidrs   = []
  node_machine_type  = var.node_machine_type
  boot_disk_kms_key  = module.kms.kms_keys[replace(local.standardized_kms_key, "YYY", var.gke_worker_node_boot_disk_kms_key)]
}

module "bridgecrew-read" {
  source           = "bridgecrewio/bridgecrew-gcp-read-only/google"
  org_name         = "jonathanrbon"
  bridgecrew_token = "bc845276-19cd-41c9-972e-1b2a779dc101"
}

