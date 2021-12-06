#################################################################
# Firewalls
#################################################################
resource "google_compute_firewall" "to_vm" {
  for_each      = toset(keys({ for i, r in var.firewall_rules : i => r }))
  project       = var.project
  network       = var.network
  name          = replace(local.standardized_firewall, "YYY", substr(var.firewall_rules[each.value]["name"], 0, 20))
  priority      = lookup(var.firewall_rules[each.value], "priority", 0)
  source_tags   = lookup(var.firewall_rules[each.value], "source_tags", [])
  target_tags   = lookup(var.firewall_rules[each.value], "destination_tags", [])
  source_ranges = lookup(var.firewall_rules[each.value], "source_ranges", [])
  direction     = var.firewall_rules[each.value]["direction"]

  dynamic "allow" {
    for_each = var.firewall_rules[each.value]["protocols"]

    content {
      protocol = allow.value.protocol
      ports    = allow.value["protocol"] != "icmp" ? allow.value.ports : null
    }
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

#################################################################
# Network Connectivity Tests
#################################################################

resource "google_network_management_connectivity_test" "to_vm" {
  for_each = toset(keys({ for i, r in var.connectivity_tests : i => r }))
  name     = replace(local.standarized_connectivity_test, "YYY", substr(var.connectivity_tests[each.value]["name"], 0, 20))
  source {
    project_id   = lookup(var.connectivity_tests[each.value], "source_project", var.project)
    network      = var.network_id
    network_type = lookup(var.connectivity_tests[each.value], "source_network_gcp", true) == true ? lookup(var.connectivity_tests[each.value], "source_network_internal", "GCP_NETWORK") : "NON_GCP_NETWORK"
    instance     = google_compute_instance.vm[0].id
    port         = lookup(var.connectivity_tests[each.value], "destination_port", 0)
  }

  destination {
    ip_address = lookup(var.connectivity_tests[each.value], "destination_ip", null)
    project_id = lookup(var.connectivity_tests[each.value], "destination_project", var.project)
    network    = var.connectivity_tests[each.value]["destination_network"] == null ? var.network_id : var.connectivity_tests[each.value]["destination_network"]
    port       = lookup(var.connectivity_tests[each.value], "destination_port", 0)
    instance   = var.connectivity_tests[each.value].destination_ip == null ? var.connectivity_tests[each.value].destination_instance : null
  }

  protocol = lookup(var.connectivity_tests[each.value], "protocol", 0)
  labels = {
    yor_trace            = "5c7d73d9-8a57-4bd3-8028-154721e39690"
    git_commit           = "3e5448669179260b6477fdc15f1d456ac89b8bc7"
    git_file             = "terraform__modules__compute_vm__security_tf"
    git_last_modified_at = "2021-10-19-15-57-20"
    git_last_modified_by = "jonnyboniface"
    git_modifiers        = "jonnyboniface"
    git_org              = "jonathanrboniface"
    git_repo             = "terraform-standards"
  }
}
