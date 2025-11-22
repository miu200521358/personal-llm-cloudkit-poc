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

resource "google_storage_bucket" "db_bucket" {
  name                        = var.gcs_bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}

resource "google_cloud_run_v2_service" "llm_webui" {
  name     = var.cloud_run_service_name
  location = var.region

  template {
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    volumes {
      name = "gcs-db"

      gcs {
        bucket    = google_storage_bucket.db_bucket.name
        read_only = false
      }
    }

    containers {
      name  = "openwebui"
      image = var.openwebui_image

      env {
        name  = "OPENAI_API_BASE"
        value = "http://127.0.0.1:11434/v1"
      }

      env {
        name  = "OPENAI_API_KEY"
        value = "dummy"
      }

      env {
        name  = "DATA_DIR"
        value = "/app/backend/data"
      }

      volume_mounts {
        name       = "gcs-db"
        mount_path = "/app/backend/data"
      }

      ports {
        container_port = 8080
      }

      resources {
        cpu_idle = true
      }
    }

    containers {
      name  = "ollama"
      image = var.ollama_image

      command = ["ollama"]
      args    = ["serve"]

      ports {
        container_port = 11434
      }

      resources {
        cpu_idle = true
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  depends_on = [google_storage_bucket.db_bucket]
}
