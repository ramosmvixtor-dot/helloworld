variable "project_id" {
  type        = string
  description = "The Google Cloud Project ID"
  default     = "project-3a299cbc-eb46-46b5-b07"
}

variable "region" {
  type        = string
  description = "The Google Cloud Region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "The Google Cloud Zone"
  default     = "us-central1-c"
}

variable "service_account_email" {
  type        = string
  description = "The email of the Service Account to use for GKE nodes and Artifact Registry access"
  default     = "sa-google@project-3a299cbc-eb46-46b5-b07.iam.gserviceaccount.com"
}

variable "gke_num_nodes" {
  type        = number
  description = "Number of nodes per zone in the GKE cluster"
  default     = 1
}

variable "gke_cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
  default     = "gke-microservicios-pruebas"
}

variable "repository_id" {
  type        = string
  description = "The ID of the Artifact Registry repository"
  default     = "registry-demo"
}
