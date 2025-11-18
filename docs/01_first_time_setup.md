# 01. First-time setup

Terraform を GitHub Actions から実行する場合は、以下の Secrets をリポジトリに登録してください。ワークフローは `TF_VAR_` から始まる環境変数を Terraform 変数に自動でマッピングします。

| Secret 名（推奨） | 代替 Secret 名 | 説明 | 例 |
| --- | --- | --- | --- |
| `TF_VAR_PROJECT_ID` | `GCP_PROJECT_ID` | GCP プロジェクト ID | `personal-llm-dev` |
| `TF_VAR_REGION` | `GCP_REGION` | デプロイ先リージョン | `asia-northeast1` |
| `TF_VAR_USER_EMAIL` | `GCP_USER_EMAIL` | デプロイ通知などで利用するユーザーのメールアドレス | `you@example.com` |
| `TF_VAR_GCS_BUCKET_NAME` | `GCS_BUCKET_NAME` | 永続化用 Cloud Storage バケット名 | `personal-llm-storage-123` |
| `GCP_SA_KEY_JSON` | （なし） | Terraform 用サービスアカウント JSON（文字列として貼り付け） | `{ "type": "service_account", ... }` |

> `.github/workflows/terraform-plan.yml` では、表の左列（推奨）から順に Secret を参照し、未設定の場合は代替列を利用します。どちらか片方を登録すれば自動的に Terraform 変数へマッピングされます。

> `GCP_SA_KEY_JSON` は JSON 全文を 1 つの Secret として保存します。貼り付ける際は改行を含めてそのまま入力してください。ワークフロー側で `TF_VAR_google_credentials_json` として Terraform に渡されます。

## サービスアカウントの準備

1. GCP プロジェクトで Terraform 実行専用のサービスアカウントを作成します。
2. 少なくともリソース作成に必要なロール（例: `roles/storage.admin`）を付与します。
3. JSON キーをダウンロードし、上記 `GCP_SA_KEY_JSON` Secret に登録します。

## 動作確認

- Pull Request が作成または更新されるたびに、`.github/workflows/terraform-plan.yml` が起動し、`infra/` ディレクトリで `terraform fmt` / `init` / `validate` / `plan` を実行します。
- すべての Secrets が正しく登録されていれば、Plan の実行結果が PR の Checks に表示されます。

## トラブルシューティング：`terraform-plan` が失敗する

CI チェックで `terraform plan` が失敗する場合は、次の項目を見直してください。

1. 上記 5 つの Secrets がすべて登録されているか。特に `GCP_SA_KEY_JSON` が空のままだと「Attempted to load application default credentials...」のような認証エラーになります。
2. `GCP_SA_KEY_JSON` に貼り付けた JSON が Terraform 用サービスアカウントのキーと一致しているか（別のサービスアカウントでは認可されません）。
3. サービスアカウントに、対象プロジェクトの Cloud Storage へアクセスできる権限（例: `roles/storage.admin`）とプロジェクト参照権限（`roles/viewer` など）が与えられているか。

これらを満たしていれば、ワークフローが `TF_VAR_google_credentials_json` として JSON を Terraform に引き渡し、Pull Request 上で `terraform plan` まで到達できます。
