#################################################################
# Main
#################################################################
resource "google_dns_managed_zone" "forwarding-zone" {
  for_each = { for k, v in local.dns_zones_flattened : k => v if contains(values(v), "forwarding") }
  name     = each.value["name"]
  dns_name = each.value["dns_zone"]
  labels = {
    foo = "bar"
  }

  visibility = each.value["visibility"]

  private_visibility_config {
    dynamic "networks" {
      for_each = var.networks_visibility_forwarding
      content {
        network_url = networks.value
      }
    }
  }

  forwarding_config {
    dynamic "target_name_servers" {
      for_each = var.target_dns_servers
      content {
        ipv4_address    = target_name_servers.value
        forwarding_path = var.private_forwarding_path ? "private" : "default"
      }
    }
  }
}

resource "google_dns_managed_zone" "peering-zone" {
  for_each   = { for k, v in local.dns_zones_flattened : k => v if contains(values(v), "peering") }
  name       = each.value["name"]
  dns_name   = each.value["dns_zone"]
  visibility = each.value["visibility"]

  private_visibility_config {
    dynamic "networks" {
      for_each = var.networks_visibility_peering
      content {
        network_url = networks.value
      }
    }
  }

  peering_config {
    dynamic "target_network" {
      for_each = var.network_peers
      content {
        network_url = target_network.value
      }
    }
  }
}

resource "google_dns_managed_zone" "basic" {
  for_each   = { for k, v in local.dns_zones_flattened : k => v if contains(values(v), "basic") }
  name       = each.value["name"]
  dns_name   = each.value["dns_zone"]
  visibility = each.value["visibility"]

  private_visibility_config {
    dynamic "networks" {
      for_each = var.networks_visibility_peering
      content {
        network_url = networks.value
      }
    }
  }
}

resource "google_dns_record_set" "a" {
  for_each     = { for k, v in local.dns_records_flattened : k => v }
  name         = each.value["name"]
  managed_zone = each.value["dns_zone"]
  type         = each.value["type"]
  ttl          = each.value["ttl"]
  rrdatas      = each.value["rrdatas"]
}
