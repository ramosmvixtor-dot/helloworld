resource "google_artifact_registry_repository" "registry" {
  location      = var.region
  repository_id = var.repository_id
  description   = "Google Artifact Registry Repository"
  format        = "DOCKER"
  cleanup_policy_dry_run = true
}

resource "google_artifact_registry_repository_iam_member" "reader" {
  project    = google_artifact_registry_repository.registry.project
  location   = google_artifact_registry_repository.registry.location
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.service_account_email}"
}
