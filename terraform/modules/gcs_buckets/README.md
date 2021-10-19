# terraform-google-storage-bucket
Terraform module to create and manage the storage bucket.


## Usage

```hcl
module "create_bucket" {
  source               = "git::ssh://git@bitbucket.org/oiq/ops-gcp-tf-module-bucket?ref=v1.0.0"
  project              = var.project
  region               = var.region
  env                  = var.env
  org                  = var.org
  description          = "gcs"
  default_kms_key_name = module.kms.kms_keys[replace(local.standardized_kms_key, "YYY", var.bucket_kms_key)]
  bucket_properties    = var.bucket_properties
}

## Sample bucket property definition
bucket_properties = [
  {
    name                        = "oms-dbbackup"
    storage_class               = "STANDARD"
    force_destroy               = false
    uniform_bucket_level_access = true
    versioning_enabled          = false
    retention_policy            = [
      {
        is_locked = false,
        retention_period = 31536000
      }
    ]
    lifecycle_rules             = [
      {
        action  = {
          type = "SetStorageClass"
          storage_class = "NEARLINE"
        }
        condition = {
          age = 30
        }
      }
    ]
    service_account_create      = false
    service_account_name        = "windows-service-2"
    service_account_desc        = ""
  },
  {
    name                        = "doc-store"
    storage_class               = "STANDARD"
    force_destroy               = false
    uniform_bucket_level_access = true
    versioning_enabled          = true
    retention_policy            = []
    lifecycle_rules             = []
    service_account_create      = false
    service_account_name        = "windows-service"
    service_account_desc        = ""
  }
]
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| google | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.0 |

## Inputs
bucket_properties: Bucket properties containing the following required items to create one or muliptle buckets:
  name: The GCS bucket name.
  storage_class:  The Storage Class of the new bucket. Allowed values: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`.
  force_destroy:  When deleting a bucket, this boolean option will delete all contained objects.
  uniform_bucket_level_access: When you enable uniform bucket-level access on a bucket, Access Control Lists (ACLs) are disabled, and only bucket-level Identity and Access Management (IAM) permissions grant access to that bucket and the objects it contains.
  versioning_enabled: While set to `true`, versioning is fully enabled for this bucket.
  retention_policy: Configuration of the bucket's data retention policy for how long objects in the bucket should be retained.
  lifecycle_rules:  The list of bucket Lifecycle Rules.
  service_account_create: Access the bucket using a service account.
  service_account_name: : Service account name.
  service_account_desc: Service account description.
project:  The project indicates the default GCP project all of your resources will be created in.
region: The region will be used to choose the default location for regional resources.
env: The environment being deployed into.
org:  Name of organization, used for naming resources.
description: Used to describe resource, should be kept short as its used in the naming convention.
default_kms_key_name: The `id` of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified.

## Outputs

| Name | Description |
|------|-------------|
| name | The name of bucket |
| self\_link | The URI of the created resource |
| url | The base URL of the bucket, in the format gs://<bucket-name> |

<!--- END_TF_DOCS --->

