// variables.tf
variable "project_id" {
  description = "GCP project ID where the infrastructure will be created."
  type        = string
}

variable "region" {
  description = "Region in which to deploy resources (e.g., asia-northeast1)."
  type        = string
}

variable "user_email" {
  description = "Google account email that will receive Cloud Run Invoker permissions."
  type        = string
}

variable "artifact_repository_name" {
  description = "Artifact Registry repository name used for container images."
  type        = string
  default     = "llm"
}

variable "cloud_run_service_name" {
  description = "Cloud Run service name for the Open WebUI deployment."
  type        = string
  default     = "llm-webui"
}

variable "gcs_bucket_name" {
  description = "GCS bucket name for persisting the SQLite database (must be globally unique)."
  type        = string
  default     = "llm-webui-data"
}
