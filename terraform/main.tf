data "google_project" "project" {}

provider "google" {
  project = "godocker-456220"
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}