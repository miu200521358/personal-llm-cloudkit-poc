# personal-llm-cloudkit-poc

## Terraform の実行方法

Google Cloud 上のリソースを操作するため、`terraform plan`/`apply` を実行する際には **サービスアカウントの認証情報** が必要です。次の手順でセットアップしてください。

1. GCP プロジェクト上で Terraform 用のサービスアカウントを作成し、必要な権限（例: `Storage Admin`）を付与します。
2. サービスアカウントの JSON 鍵をダウンロードします。
3. ローカル or CI/CD 環境で以下のように JSON を Terraform 変数 `google_credentials_json` に渡します。

```bash
export TF_VAR_project_id="your-project"
export TF_VAR_region="asia-northeast1"
export TF_VAR_user_email="you@example.com"
export TF_VAR_gcs_bucket_name="your-unique-bucket"
export TF_VAR_google_credentials_json="$(cat path/to/service-account.json)"

terraform -chdir=infra init
terraform -chdir=infra plan -input=false
```

GitHub Actions などで実行する場合は、サービスアカウント JSON を Secrets（例: `GCP_SERVICE_ACCOUNT_KEY`）として登録し、Workflow から `TF_VAR_google_credentials_json` 環境変数へ渡してください。これにより、CI 上でも `terraform plan` を実行できます。
