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
  labels = {
    yor_trace            = "a794d606-1652-4129-9922-d267049e6d3c"
    git_commit           = "3e5448669179260b6477fdc15f1d456ac89b8bc7"
    git_file             = "terraform__modules__kms_keys__main_tf"
    git_last_modified_at = "2021-10-19-15-57-20"
    git_last_modified_by = "jonnyboniface"
    git_modifiers        = "jonnyboniface"
    git_org              = "jonathanrboniface"
    git_repo             = "terraform-standards"
  }
}
