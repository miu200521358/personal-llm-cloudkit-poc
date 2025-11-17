## 概要（Summary）

- この PR で解決する目的・背景を 2〜3 行で記載してください。

---

## 関連 Issue

- Fixes #<Issue 番号>

---

## 変更内容（What was changed）

- [ ] Terraform コード
- [ ] GitHub Actions ワークフロー
- [ ] ドキュメント（README / AGENTS.md など）
- [ ] その他（記載してください）

具体的な変更点を箇条書きで記述：

- 例）`infra/variables.tf` に `project_id` などの変数を追加
- 例）`.github/workflows/deploy-llm-on-gcp.yml` に Terraform 実行ステップを追加

---

## Terraform 検証結果

> **Codex はここに最新の検証結果を必ず貼り付けること**

- 実行環境（ローカル / Codex 環境など）：

### terraform fmt

- コマンド：
  - `terraform -chdir=infra fmt -check`
- 結果：
  - 成功 / 失敗（エラーがあれば抜粋）

### terraform validate

- コマンド：
  - `terraform -chdir=infra validate`
- 結果：
  - 成功 / 失敗（エラーがあれば抜粋）

### terraform plan

- コマンド：
  - `terraform -chdir=infra plan -input=false`  
- 結果概要：
  - `+` 作成リソース：
  - `~` 変更リソース：
  - `-` 削除リソース：
- 必要に応じて plan 出力の末尾を貼り付けるか、Gist 等へのリンクを記載：

```text
（plan 出力の抜粋をここに貼る／長い場合は Gist の URL）
````

---

## GitHub Actions / その他テスト
- 対象ワークフロー（例：deploy-llm-on-gcp）：
- 実行方法（手動 / push トリガーなど）：
- 結果：
    -成功 / 失敗（ログの重要部分を記載）

---

## 破壊的変更・リスク

- [ ] 破壊的変更は 含まれていない
- [ ] 破壊的変更を含む（内容と影響を下記に記載）

詳細：
- 例）既存の Cloud Run サービス名を変更したため、古い URL は利用できなくなる など

$$$ チェックリスト

 - [ ] 対応した Issue のスコープ外の変更は行っていない
 - [ ] AGENTS.md のルール（特に Terraform 検証／PR テンプレ遵守）に従っている
 - [ ] 命名・ディレクトリ構成が Issue #1（全体仕様）と矛盾していない
 - [ ] 必要に応じてドキュメント（README / AGENTS.md / docs/*）を更新した
