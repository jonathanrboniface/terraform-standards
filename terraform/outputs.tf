output "vpc_private" {
  value = module.network_private
}

output "kms_keyring_name" {
  value = module.kms.kms_keyring_name
}

output "kms_keys" {
  value = module.kms.kms_keys
}


output "vpc" {
  value = { "private" : module.network_private
  }
}
