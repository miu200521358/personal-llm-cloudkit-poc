// providers.tf
terraform {
  required_version = ">= 1.5.0"

  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.32.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.11.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google" {
  alias                 = "bootstrap"
  project               = var.project_id
  region                = var.region
  user_project_override = true
  billing_project       = var.project_id
}
