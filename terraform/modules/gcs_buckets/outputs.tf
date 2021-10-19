output "self_link" {
  value = {
    for bucket in google_storage_bucket.bucket :
    bucket.self_link => bucket.self_link
  }
  description = "The URI of the created resource"
}

output "url" {
  value = {
    for bucket in google_storage_bucket.bucket :
    bucket.url => bucket.url
  }
  description = "The base URL of the bucket, in the format gs://<bucket-name>"
}

output "name" {
  value = {
    for bucket in google_storage_bucket.bucket :
    bucket.name => bucket.name
  }
  description = "The name of bucket"
}
