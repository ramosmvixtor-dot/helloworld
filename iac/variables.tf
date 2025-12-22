variable "project_id" {
  type        = string
  description = "The Google Cloud Project ID"
}

variable "region" {
  type        = string
  description = "The Google Cloud Region"
}

variable "zone" {
  type        = string
  description = "The Google Cloud Zone"
}

variable "service_account_email" {
  type        = string
  description = "The email of the Service Account to use for GKE nodes and Artifact Registry access"
}

variable "gke_num_nodes" {
  type        = number
  description = "Number of nodes per zone in the GKE cluster"
  default     = 1
}

variable "gke_cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
}

variable "repository_id" {
  type        = string
  description = "The ID of the Artifact Registry repository"
}
