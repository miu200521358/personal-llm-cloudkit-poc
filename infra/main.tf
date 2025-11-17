// main.tf
//
// NOTE:
//   このファイルには、後続の Issue で以下のリソースを順次追加する。
//   - GCS バケット（永続DB用）
//   - Artifact Registry リポジトリ
//   - Cloud Run (Open WebUI + Ollama, CPU only, GCS Fuse)
//   - IAM (Cloud Run Invoker を user_email に付与)
//
//   現時点では、GCS バケットのみを定義し、Terraform がエラーにならない状態を維持する。

resource "google_storage_bucket" "db_bucket" {
  name                        = var.gcs_bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
}
