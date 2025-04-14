variable "project_id" {
  description = "GCP project id."
  type        = string
  default     = "godocker-456220"
}
variable "region_name" {
  description = "GCP region name."
  type        = string
  default     = "europe-west1"
}

variable "service_account_email" {
  description = "Service account email."
  type        = string
  default     = "godocker-service-account@godocker-456220.iam.gserviceaccount.com"
}

variable "godocker_api_image" {
  description = "Number of images to keep."
  type        = string
  default     = "europe-west1-docker.pkg.dev/godocker-456220/godocker-repository/godocker-image"
}