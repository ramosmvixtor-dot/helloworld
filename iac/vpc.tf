resource "google_compute_network" "vpc" {
  name                    = "vpc-gke-main"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-gke-main"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/24"

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = "10.1.0.0/21"
  }

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.2.0.0/21"
  }
}
