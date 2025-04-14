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


resource "google_secret_manager_secret" "github-secret-godocker" {
  secret_id = "github-secret-godocker"

  labels = {
    label = "github-token-godocker"
  }

  replication {
    user_managed {
      replicas {
        location = var.region_name
      }
    }
  }
}

# resource "google_cloudbuildv2_connection" "my-connection" {
#   location = var.region_name
#   name = "my-connection"
#
#   # github_config {
#   #   app_installation_id = 123123
#   #   authorizer_credential {
#   #     oauth_token_secret_version = "projects/my-project/secrets/github-pat-secret/versions/latest"
#   #   }
#   # }
# }

# resource "google_cloudbuildv2_repository" "my-repository" {
#   name = "my-repo"
#   parent_connection = google_cloudbuildv2_connection.my-connection.id
#   remote_uri = "https://github.com:varun-jalandery/godocker.git"
# }
#
# resource "google_cloudbuild_trigger" "repo-trigger" {
#   location = var.region_name
#
#   repository_event_config {
#     repository = google_cloudbuildv2_repository.my-repository.id
#     push {
#       branch = "main"
#     }
#   }
#
#   filename = "cloudbuild.yaml"
# }
#
# resource "google_cloudbuild_trigger" "github_push_trigger" {
#   project = "your-gcp-project-id" # Replace with your GCP project ID
#   name    = "github-push-trigger"
#   github {
#     owner = "your-github-username-or-org" # Replace with your GitHub username or organization name
#     name  = "your-github-repo-name"      # Replace with your GitHub repository name
#     push {
#       branch = "^main$" # Replace with the branch pattern you want to trigger on (e.g., "main", "develop", "release/.*")
#     }
#   }
#   filename = "cloudbuild.yaml" # Replace with the path to your Cloud Build configuration file
# }