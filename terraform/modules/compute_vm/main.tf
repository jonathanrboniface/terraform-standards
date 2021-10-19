#################################################################
# Main
#################################################################
resource "google_kms_crypto_key_iam_binding" "crypto_key" {
  crypto_key_id = var.kms_key_self_link
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${var.project_number}@compute-system.iam.gserviceaccount.com",
  ]
}

resource "google_compute_instance" "vm" {
  for_each = { for k, v in local.name_ids : k => v }

  name                      = "${local.standardized_compute_instance}-${each.value}"
  machine_type              = var.machine_type
  zone                      = var.zones[each.key % length(var.zones)]
  can_ip_forward            = true
  description               = var.instance_description
  tags                      = var.network_tags
  allow_stopping_for_update = true
  labels                    = merge(var.labels, {
    resource= "google-compute-instance", 
    location= var.zones[each.key % length(var.zones)]
    }
  )
  metadata = {
    windows-startup-script-ps1 = (length(local.oscheck) >= 1) ? var.windows_startup_script : null
  }

  dynamic "boot_disk" {
    for_each = { for k, v in var.boot_disk : k => v }
    content {
      auto_delete = true
      device_name = boot_disk.value["name"]
      initialize_params {
        image = boot_disk.value["source_image"]
        size  = boot_disk.value["disk_size_gb"]
        type  = boot_disk.value["disk_type"]
      }
      kms_key_self_link = var.kms_key_self_link
    }
  }

  dynamic "attached_disk" {
    for_each = { for attached_disk, v in local.disks_flattened : attached_disk => v if v.name != "boot" && v.vm_id == each.key + 1 }
    content {
      source      = google_compute_disk.vm[attached_disk.key].id
      device_name = google_compute_disk.vm[attached_disk.key].name
    }
  }

  network_interface {

    dynamic "alias_ip_range" {
      for_each = length(var.alias_cidrs) == 0 ? [] : [1]
      content {
        ip_cidr_range = var.alias_cidrs[each.key]
      }
    }

    subnetwork = var.subnets[each.key]
    network_ip = length(var.private_ips) >= 1 ? var.private_ips[each.key] : null
  }

  service_account {
    scopes = var.service_account_scopes
  }

  dynamic "shielded_instance_config" {
    for_each = var.shielded_vm ? [1] : []

    content {
      enable_secure_boot          = true
      enable_vtpm                 = true
      enable_integrity_monitoring = true
    }
  }
  scheduling {
    on_host_maintenance = var.on_host_maintenance

    dynamic "node_affinities" {
      for_each = var.sole_tenancy ? [1] : []
      content {
        key      = "active"
        operator = "IN"
        values   = [true]
      }
    }
  }
  lifecycle {
    ignore_changes = [boot_disk, attached_disk, can_ip_forward]
  }

  depends_on = [
    google_compute_disk.vm
  ]
}

resource "google_compute_disk" "vm" {
  for_each = { for k, v in local.disks_flattened : k => v }
  name     = "${local.standardized_compute_instance}-${each.value["vm_id"]}-${each.value["name"]}"
  type     = each.value["disk_type"]
  zone     = each.value["zone"]
  image    = each.value["source_image"]
  size     = each.value["disk_size_gb"]
  labels = merge(var.labels, {
    resource = "google-compute-engine-disk",
    location = each.value["zone"],
    vss      = each.value["vss"]
   }
  )
  lifecycle {
    ignore_changes = [
    snapshot]
  }
  disk_encryption_key {
    kms_key_self_link = var.kms_key_self_link
  }
}
