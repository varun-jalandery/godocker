# data "google_project" "project" {}

provider "google" {
  project = var.project_id
  region  = var.region_name
}


resource "google_artifact_registry_repository" "godocker-docker-repo" {
  location      = var.region_name
  repository_id = "godocker-repository"
  description   = "godocker docker repository"
  format        = "DOCKER"
}

resource "google_cloud_run_v2_service" "godocker-api-service" {
  name     = "godocker-api-service"
  location = var.region_name
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = var.godocker_api_image
      resources {
        limits = {
          cpu    = "2"
          memory = "1024Mi"
        }
      }
      startup_probe {
        failure_threshold     = 5
        initial_delay_seconds = 10
        timeout_seconds       = 3
        period_seconds        = 3

        http_get {
          path = "/health"
          http_headers {
            name  = "Access-Control-Allow-Origin"
            value = "*"
          }
        }
      }

    }

  }
}