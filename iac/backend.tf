terraform {
  backend "gcs" {
    bucket  = "helloworld-tfstate-project-3a299cbc"
    prefix  = "terraform/state"
  }
}
