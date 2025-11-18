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

GitHub Actions などで実行する場合は、サービスアカウント JSON を Secrets（例: `GCP_SA_KEY_JSON`）として登録し、Workflow から `TF_VAR_google_credentials_json` 環境変数へ渡してください。これにより、CI 上でも `terraform plan` を実行できます。Terraform が必要とするその他の変数も Secrets から読み込まれます。推奨の組み合わせは次のとおりです（左から順に評価されます）。

| Terraform 変数 | 推奨 Secret 名 | 代替 Secret 名 |
| --- | --- | --- |
| `project_id` | `TF_VAR_PROJECT_ID` | `GCP_PROJECT_ID` |
| `region` | `TF_VAR_REGION` | `GCP_REGION` |
| `user_email` | `TF_VAR_USER_EMAIL` | `GCP_USER_EMAIL` |
| `gcs_bucket_name` | `TF_VAR_GCS_BUCKET_NAME` | `GCS_BUCKET_NAME` |
| `google_credentials_json` | `GCP_SA_KEY_JSON` | （なし） |

具体的な Secrets 名や初期設定手順は [`docs/01_first_time_setup.md`](docs/01_first_time_setup.md) を参照してください。

> `terraform-plan` ワークフローは `pull_request_target` イベントで起動し、Secrets に保存した値（`GCP_SA_KEY_JSON` など）を Pull Request でも利用できるようにしています。ワークフロー内で PR の HEAD コミットを明示的にチェックアウトしてから Terraform を実行するため、実際の差分を安全に検証できます。

### Pull Request チェック (`terraform-plan`) が失敗する場合

GitHub Actions 上で `terraform-plan` ジョブが失敗する主な原因は、Terraform が Google Cloud に対して認証できていないことです。以下を確認してください。

1. リポジトリ Secrets に `TF_VAR_PROJECT_ID` / `TF_VAR_REGION` / `TF_VAR_USER_EMAIL` / `TF_VAR_GCS_BUCKET_NAME` / `GCP_SA_KEY_JSON` を登録し、空になっていないこと。
2. `GCP_SA_KEY_JSON` には Terraform 用サービスアカウントの JSON ファイル全文を貼り付けていること（base64 などに変換しない）。
3. そのサービスアカウントに Cloud Storage など必要なリソースへアクセスできるロールを付与し、対象プロジェクトで API が有効化されていること。

上記が揃っていれば、Workflow から `TF_VAR_google_credentials_json` として Terraform に渡され、Pull Request 上の `terraform plan` が通るようになります。
