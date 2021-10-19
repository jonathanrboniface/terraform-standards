resource "google_project_iam_member" "default-gcs-permissions" {
  role   = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member = "serviceAccount:service-${var.project_number}@gs-project-accounts.iam.gserviceaccount.com"
}

resource "google_storage_bucket" "bucket" {
  for_each                    = toset(keys({ for k, v in var.bucket_properties : k => v }))
  name                        = replace(local.standardized_bucket, "XXX", var.bucket_properties[each.value]["name"])
  location                    = var.region
  project                     = var.project
  storage_class               = var.bucket_properties[each.value]["storage_class"]
  force_destroy               = var.bucket_properties[each.value]["force_destroy"]
  uniform_bucket_level_access = var.bucket_properties[each.value]["uniform_bucket_level_access"]

  versioning {
    enabled = var.bucket_properties[each.value]["versioning_enabled"]
  }

  dynamic "retention_policy" {
    for_each = var.bucket_properties[each.value]["retention_policy"]
    content {
      is_locked        = retention_policy.value.is_locked
      retention_period = retention_policy.value.retention_period
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.bucket_properties[each.value]["lifecycle_rules"]
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                   = lookup(lifecycle_rule.value.condition, "age", null)
        created_before        = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state            = lookup(lifecycle_rule.value.condition, "with_state", lookup(lifecycle_rule.value.condition, "is_live", false) ? "LIVE" : null)
        matches_storage_class = lifecycle_rule.value.condition.matches_storage_class != null ? [lookup(lifecycle_rule.value.condition, "matches_storage_class", null)] : null
        num_newer_versions    = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
      }
    }
  }

  dynamic "encryption" {
    for_each = var.bucket_properties[each.value]["kms_key"] != "" ? [1] : []
    content {
      default_kms_key_name = lookup(tomap(var.kms_keys), replace(local.standardized_kms_key, "YYY", var.bucket_properties[each.value]["kms_key"]), "")
    }
  }
  depends_on = [google_project_iam_member.default-gcs-permissions]
}

resource "google_service_account" "service_account" {
  for_each     = toset(keys({ for k, v in var.bucket_properties : k => v if v.service_account_create != false }))
  account_id   = var.bucket_properties[each.value]["service_account_name"]
  display_name = var.bucket_properties[each.value]["service_account_desc"]
}

resource "google_storage_bucket_iam_binding" "binding" {
  for_each = toset(keys({ for k, v in var.bucket_properties : k => v if v.service_account_create != false }))
  bucket   = google_storage_bucket.bucket[each.value].name
  role     = "roles/storage.admin"
  members = [
    "serviceAccount:${var.bucket_properties[each.value]["service_account_name"]}@${var.project}.iam.gserviceaccount.com",
  ]
  depends_on = [google_project_iam_member.default-gcs-permissions, google_storage_bucket.bucket, google_service_account.service_account]
}
