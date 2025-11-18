# personal-llm-cloudkit 初回セットアップ手順

> この手順は **personal-llm-cloudkit（CPU 版）を初めて構築する前に人間が一度だけ行う手動作業** をまとめたものです。
> ここまで完了すれば、以降は GitHub Actions が自動でインフラを構築します。

## 0. 前提条件
- スマートフォンのみでも実施できます（PC があればコピー&ペーストがより簡単になります）。
- Google アカウント（Gmail）が必要です。未取得の場合は https://accounts.google.com から作成してください。
- GitHub 無料アカウントで問題ありません。
- クレジットカード（GCP 利用登録に必須）が手元にあること。
- 安定したネットワークと、JSON ファイルを安全に保管できる環境。

---

## 1. GitHub アカウントを作成
1. https://github.com/signup にアクセス。
2. メールアドレスを入力し、届いた確認コードで認証します。
3. パスワード・ユーザー名を設定し、アンケートを完了します。
4. セキュリティ強化のため 2 要素認証（2FA）を **必須で有効化** してください。
   - GitHub アプリ / Authenticator / SMS など任意の方法で OK。

> **スクリーンショット推奨**: `docs/images/github-signup.png`（Create your account 画面）、`docs/images/github-2fa.png`（2FA 設定画面）。

---

## 2. personal-llm-cloudkit リポジトリをフォーク
1. https://github.com/miu200521358/personal-llm-cloudkit-poc を開きます。
2. 画面右上の **Fork** を押し、自分のアカウント配下へフォークします。
3. フォーク後、自分のリポジトリ（例: `https://github.com/<you>/personal-llm-cloudkit-poc`）へ移動します。
4. 以降の設定（GitHub Secrets 追加など）は **フォーク先リポジトリ** で行います。

> クローンしたい場合は `git clone https://github.com/<you>/personal-llm-cloudkit-poc.git` を PC で実行しても構いません。
> **スクリーンショット推奨**: `docs/images/github-fork.png`（Fork ボタン）、`docs/images/github-secrets-entry.png`（Settings → Secrets）。

---

## 3. GCP アカウントを作成
1. https://cloud.google.com/ にアクセスし **無料トライアルを開始** を押します。
2. 既存の Google アカウントでログイン（または新規作成）します。
3. 利用規約に同意し、クレジットカードを登録します。
4. 無料枠の範囲を超えた課金を避けるため、課金アラートを設定することを推奨します。
   - 参考: https://cloud.google.com/billing/docs/how-to/budgets 

---

## 4. GCP プロジェクトを作成
1. https://console.cloud.google.com/ へアクセス。
2. 画面上部のプロジェクトセレクタから **新しいプロジェクト** をクリック。
3. プロジェクト名と課金アカウントを指定して作成します。
4. 「プロジェクト ID」は後で Terraform や GitHub Secrets に入力するため、メモしてください。

> **スクリーンショット推奨**: `docs/images/gcp-create-project.png`（新しいプロジェクト画面）、`docs/images/gcp-project-id.png`（プロジェクト ID 表示）。

---

## 5. Terraform 実行用サービスアカウントを作成
1. GCP コンソール左上のハンバーガーメニュー → **IAM と管理** → **サービスアカウント** を開きます。
2. **+ 作成** を押し、以下を入力。
   - 名前例: `terraform-runner`
   - ID 例: `terraform-runner`
   - 説明: 「personal-llm-cloudkit 自動デプロイ用」
3. 権限付与ステップで以下のいずれかを選択します。
   - **シンプル案**: `Editor` ロール 1 つ。
   - **最小権限案**（推奨・4 つのロールを付与）:
     - `roles/storage.admin`
     - `roles/run.admin`
     - `roles/artifactregistry.admin`
     - `roles/iam.serviceAccountUser`
4. 「ユーザーへのアクセス権の付与」はスキップして完了します。
※ Cloud Run や Artifact Registry を扱うため、最小権限案では上記 4 つのロールが必須です。

> **スクリーンショット推奨**: `docs/images/gcp-sa-create.png`（サービスアカウント作成画面）、`docs/images/gcp-sa-roles.png`（ロール付与画面）。

---

## 6. サービスアカウント JSON キーを生成
1. 作成したサービスアカウントの詳細ページを開き、上部タブの **鍵** を選択。
2. **鍵を追加** → **新しい鍵を作成** → **JSON** を選んで作成します。
3. JSON ファイル（例: `terraform-runner-<hash>.json`）が端末にダウンロードされます。
4. スマホの場合は安全な場所（Files アプリやクラウドストレージ）に保存し、第三者へ共有しないでください。
5. 後ほど GitHub Secrets `GCP_SA_KEY_JSON` でファイル内容をそのままコピーして貼り付けます。

> **スクリーンショット推奨**: `docs/images/gcp-sa-key.png`（鍵を追加 → JSON）。
> **注意**: JSON をメール等で送らない。万一漏洩した場合は鍵を削除し再発行してください。

---

## 7. GitHub Secrets を設定
1. フォークしたリポジトリのトップ → **Settings** → **Secrets and variables** → **Actions** を開きます。
2. **New repository secret** を押して、以下のキーと値を登録します。

| Secret 名 | 値の例 / 説明 |
| --- | --- |
| `GCP_PROJECT_ID` | 例: `personal-llm-123456`（手順 4 で控えた ID） |
| `GCP_REGION` | 例: `asia-northeast1`（Cloud Run を置きたいリージョン。課金とレイテンシーで選択） |
| `GCP_SA_KEY_JSON` | 手順 6 で生成した JSON の全文（`{` から `}` までコピーして貼り付け） |
| `USER_EMAIL` | 自分の Google アカウント（Cloud Run 利用者のメールアドレス） |
| `SENDGRID_API_KEY` | Issue #6 で取得予定の SendGrid API キー。未取得の場合は後から追加可能なため、現時点ではこのシークレットを作成しなくて問題ありません。 |
| `MAIL_FROM` | 送信元メールアドレス（SendGrid で認証したもの） |

> **スクリーンショット推奨**: `docs/images/github-secret.png`（New repository secret 画面）。
> JSON を貼り付ける際は、スマホならメモ帳アプリに一度貼って全選択→コピー→Secrets へ貼ると改行が崩れません。

---

## 8. GitHub Actions で構築を開始
1. フォーク先リポジトリの **Actions** タブを開きます。
2. ワークフロー一覧から `deploy-llm-on-gcp` を選択。
3. 右上の **Run workflow** を押し、デフォルト設定のまま実行します。
4. 10〜20 分程度で Terraform と Cloud Run の構築が完了し、GitHub Actions のログで成功を確認できます。
5. 完了後、`USER_EMAIL` で登録したメールに Open WebUI の URL が届きます。Google 認証でログインすれば個人専用環境を利用できます。
> **スクリーンショット推奨**: `docs/images/github-actions-run.png`（Run workflow ボタン）、`docs/images/github-actions-success.png`（成功ログ）。

---

## 9. 推奨される追加手動作業
- **GCP 課金アラート**: プロジェクトの予算通知を設定し、想定外の課金を防止。
- **IAM ロール確認**: `USER_EMAIL` のユーザー自身がプロジェクトのオーナーまたは十分な権限を持っているか確認。
- **必要 API の有効化**: Cloud Run / Artifact Registry / IAM API などは Terraform でも自動有効化されますが、構築前に有効化しておくと初回デプロイが安定します。
- **JSON キーの管理**: 端末紛失時に備え、ダウンロード後は安全なストレージに移し、公開クラウドへは置かない。

---

## 10. 次にやること
- ここまで完了していれば、GitHub Actions がフル自動で personal-llm-cloudkit のインフラを構築します。
- SendGrid など追加サービスのセットアップが必要な場合は、該当 Issue の手順に従ってください。
- 手順書にスクリーンショットを追加したい場合は `docs/images/` などを作成し、画像ファイルを配置してください（本 Issue ではパス記述のみで可）。

---

## トラブルシューティング（よくある質問）
- **GitHub Actions が失敗する**: Secrets のスペル、プロジェクト ID、JSON の改行漏れを再確認してください。
- **GCP プロジェクトが選べない**: 課金アカウントが紐づいているか確認してください。
- **JSON をスマホで開けない**: メモ帳アプリでファイルを開き、全選択→コピーを行います。iOS では「ファイル」アプリ、Android では「ファイル」アプリまたは Google ドライブで閲覧できます。

---

以上で初回セットアップは完了です。以降の環境構築・更新は GitHub Actions が担当するため、基本的に追加の手動作業は不要です。
