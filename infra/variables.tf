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

variable "openwebui_image" {
  description = "Container image for the Open WebUI service."
  type        = string
  default     = "ghcr.io/open-webui/open-webui:main"
}

variable "ollama_image" {
  description = "Container image for the Ollama service (CPU model)."
  type        = string
  default     = "ollama/ollama:latest"
}

variable "gcs_bucket_name" {
  description = "GCS bucket name for persisting the SQLite database (must be globally unique). Consider appending your project_id for uniqueness."
  type        = string
}

variable "access_token" {
  description = "Optional Google Cloud access token for non-interactive or mock runs (leave empty to use Application Default Credentials)."
  type        = string
  default     = ""
  sensitive   = true
}
