// main.tf
//
// NOTE:
//   このファイルには、後続の Issue で以下のリソースを順次追加する。
//   - GCS バケット（永続DB用）
//   - Artifact Registry リポジトリ
//   - Cloud Run (Open WebUI + Ollama, CPU only, GCS Fuse)
//   - IAM (Cloud Run Invoker を user_email に付与)
//
//   現時点では、Terraform がエラーにならないよう、空の状態を保つ。
