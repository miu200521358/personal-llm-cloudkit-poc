// providers.tf
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.32.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region

  access_token = trimspace(var.access_token) == "" ? null : var.access_token
}
