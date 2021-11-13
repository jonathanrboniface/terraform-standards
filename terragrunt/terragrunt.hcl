locals {
  tf_bknd_bucket = "tf-state-stroage"
  stack          = "stack-insight3pm"

  // TESTING REQUIRED
  # Automatically load account-level variables
  account_vars = read_terragrunt_config("${get_parent_terragrunt_dir()}/${get_env("TF_VAR_env", "prod")}/account.hcl")

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
}
// TESTING REQUIRED
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)

terraform {
  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh",
      "destroy"
    ]

    required_var_files = [
      "${get_terragrunt_dir()}/./common.tfvars",
    ]
    optional_var_files = [
      "${get_terragrunt_dir()}/./${get_env("TF_VAR_env", "endor-327818")}.tfvars",
    ]
  }

}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "skip"
  }
  config = {
    bucket = local.tf_bknd_bucket
    prefix = "${get_env("TF_VAR_env", "endor-327818")}/"
  }
}

generate "provider-google" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = var.project
  region = var.region
}
provider "google-beta" {
  project = var.project
  region = var.region
}
EOF
}
