#################################################################
# Main
#################################################################
resource "google_kms_key_ring" "keyring" {
  count    = var.create_kms_key_ring ? 1 : 0
  name     = local.standardized_kms_keyring
  location = var.region
  project  = var.project
}

resource "google_kms_crypto_key" "key" {
  for_each        = { for k, v in var.keys : k => v }
  name            = replace(local.standardized_kms_key, "YYY", each.value["component"])
  key_ring        = var.create_kms_key_ring ? google_kms_key_ring.keyring[0].self_link : data.google_kms_key_ring.key_ring[0].self_link
  rotation_period = var.rotation_period

  lifecycle {
    prevent_destroy = true
  }
}
