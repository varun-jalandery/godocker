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
