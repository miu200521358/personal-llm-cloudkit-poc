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
  # サービスアカウント JSON を直接渡したい場合は
  # TF_VAR_google_credentials_json などで供給する。
  # 未指定の場合は ADC (Application Default Credentials) を利用する。
  credentials = var.google_credentials_json
}

