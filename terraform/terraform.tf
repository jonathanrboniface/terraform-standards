terraform {
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 3.86.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.86.0"
    }
  }
  required_version = "~> 0.14"
  backend "gcs" {
    bucket = "tf-state-stroage"
    prefix = "endor-327818"
  }
}

data "terraform_remote_state" "endor" {
  backend = "gcs"
  config = {
    bucket = "tf-state-stroage"
    prefix = "endor-327818"
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region
}
