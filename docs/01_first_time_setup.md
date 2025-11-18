# 01. First-time setup

Terraform を GitHub Actions から実行する場合は、以下の Secrets をリポジトリに登録してください。ワークフローは `TF_VAR_` から始まる環境変数を Terraform 変数に自動でマッピングします。

| Secret 名 | 説明 | 例 |
| --- | --- | --- |
| `TF_VAR_PROJECT_ID` | GCP プロジェクト ID | `personal-llm-dev` |
| `TF_VAR_REGION` | デプロイ先リージョン | `asia-northeast1` |
| `TF_VAR_USER_EMAIL` | デプロイ通知などで利用するユーザーのメールアドレス | `you@example.com` |
| `TF_VAR_GCS_BUCKET_NAME` | 永続化用 Cloud Storage バケット名 | `personal-llm-storage-123` |
| `TF_VAR_GOOGLE_CREDENTIALS_JSON` | Terraform 用サービスアカウント JSON（文字列として貼り付け） | `{ "type": "service_account", ... }` |

> `TF_VAR_GOOGLE_CREDENTIALS_JSON` は JSON 全文を 1 つの Secret として保存します。貼り付ける際は改行を含めてそのまま入力してください。

## サービスアカウントの準備

1. GCP プロジェクトで Terraform 実行専用のサービスアカウントを作成します。
2. 少なくともリソース作成に必要なロール（例: `roles/storage.admin`）を付与します。
3. JSON キーをダウンロードし、上記 `TF_VAR_GOOGLE_CREDENTIALS_JSON` Secret に登録します。

## 動作確認

- Pull Request が作成または更新されるたびに、`.github/workflows/terraform-plan.yml` が起動し、`infra/` ディレクトリで `terraform fmt` / `init` / `validate` / `plan` を実行します。
- すべての Secrets が正しく登録されていれば、Plan の実行結果が PR の Checks に表示されます。
