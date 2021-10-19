output "kms_keyring_name" {
  value = [google_kms_key_ring.keyring.*.self_link]
}

output "kms_keys" {
  value = {
    for crypto_key in google_kms_crypto_key.key :
    crypto_key.name => crypto_key.self_link
  }
}
