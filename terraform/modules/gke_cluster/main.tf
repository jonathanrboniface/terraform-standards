#################################################################
# Main
#################################################################
resource "google_container_cluster" "gke" {
  name                     = local.standardized_gke_cluster
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network
  subnetwork               = var.subnet
  monitoring_service       = var.monitoring_service
  logging_service          = var.logging_service
  min_master_version       = var.min_master_version
  enable_shielded_nodes    = var.enable_shielded_nodes
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

  private_cluster_config {
    enable_private_nodes    = var.private_cluster
    enable_private_endpoint = var.private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.authorized_cidrs

      content {
        cidr_block   = cidr_blocks.value["cidr"]
        display_name = cidr_blocks.value["display_name"]
      }
    }

  }

  lifecycle {
    ignore_changes = [
      node_pool
    ]
  }
}


resource "google_container_node_pool" "default" {
  provider           = google-beta
  cluster            = google_container_cluster.gke.name
  initial_node_count = var.initial_node_count
  location           = var.region

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = var.node_auto_repair
    auto_upgrade = false #var.node_auto_upgrade
  }
  #TODO: version or auto upgrade but not both
  version = var.min_master_version

  node_config {
    machine_type = var.node_machine_type
    image_type   = "COS"
    oauth_scopes = local.oauth_scopes
    preemptible  = var.node_preemptible
    metadata = {
      disable-legacy-endpoints = "true"
    }
    boot_disk_kms_key = var.boot_disk_kms_key
  }

  lifecycle {
    create_before_destroy = true
  }
}
