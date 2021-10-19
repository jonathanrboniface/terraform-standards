resource "google_compute_network" "vpc" {
  name                    = local.standardized_network
  description             = var.description
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  provider                 = google-beta
  count                    = length(var.subnets)
  name                     = local.standardized_subnets[count.index]
  ip_cidr_range            = var.subnets[count.index].cidr
  network                  = google_compute_network.vpc.self_link
  region                   = var.region
  private_ip_google_access = var.subnets[count.index]["name"] == "lb" ? false : true
  purpose                  = var.subnets[count.index]["name"] == "lb" ? "INTERNAL_HTTPS_LOAD_BALANCER" : "PRIVATE"
  role                     = var.subnets[count.index]["name"] == "lb" ? "ACTIVE" : null
  dynamic "log_config" {
    for_each = var.subnets[count.index]["name"] == "lb" ? [] : [1]
    content {
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_router" "this" {
  count   = local.nat_resource_count
  name    = local.standardized_router
  region  = var.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "this" {
  count                              = local.nat_resource_count
  name                               = local.standardized_router_nat
  router                             = google_compute_router.this[count.index].name
  region                             = var.region
  nat_ip_allocate_option             = var.nat_ip_enable_static == true ? "MANUAL_ONLY" : "AUTO_ONLY"
  nat_ips                            = var.nat_ip_enable_static == true ? concat([google_compute_address.nat_static_ip.self_link], local.nat_ips) : []
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  min_ports_per_vm                   = var.nat_min_ports_per_vm
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_address" "nat_static_ip" {
  name   = replace(local.standardized_external_ip, "YYY", "natgateway")
  region = var.region
}

resource "google_compute_address" "nat_static_ip_additional" {
  count  = var.nat_additional_ips
  name   = replace(local.standardized_external_ip, "YYY", "natgateway${count.index}")
  region = var.region
}

resource "google_compute_network_peering" "this_to_other" {
  count                = length(var.peer_to_vpcs)
  name                 = replace(local.standardized_network_peering, "YYY", "${var.description}2${var.peer_to_vpcs[count.index].name}")
  network              = google_compute_network.vpc.id
  peer_network         = var.peer_to_vpcs[count.index].id
  import_custom_routes = var.peer_to_vpcs[count.index].import_routes
  export_custom_routes = true
}

resource "google_compute_network_peering" "other_to_this" {
  count                = length(var.peer_to_vpcs)
  name                 = replace(local.standardized_network_peering, "YYY", "${var.peer_to_vpcs[count.index].name}2${var.description}")
  network              = var.peer_to_vpcs[count.index].id
  peer_network         = google_compute_network.vpc.id
  export_custom_routes = var.peer_to_vpcs[count.index].export_routes
  import_custom_routes = true
}
