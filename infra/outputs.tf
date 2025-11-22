output "gcs_bucket_name" {
  description = "永続DB用 GCS バケット名"
  value       = google_storage_bucket.db_bucket.name
}

output "cloud_run_url" {
  description = "デプロイされた Open WebUI (Cloud Run) の URL"
  value       = google_cloud_run_v2_service.llm_webui.uri
}