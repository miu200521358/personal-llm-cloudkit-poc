// outputs.tf
//
// NOTE:
//   後続 Issue で以下の output を追加する予定。
//   - cloud_run_url      : デプロイされた Open WebUI (Cloud Run) の URL
//   - gcs_bucket_name    : 永続DB用 GCS バケット名
//
//   現時点では、リソース未定義のため output は未記載とする。

output "gcs_bucket_name" {
  description = "永続DB用 GCS バケット名"
  value       = google_storage_bucket.db_bucket.name
}
