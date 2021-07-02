terraform {
  required_providers {
    google = {
      source      = "hashicorp/google"
      version     = "3.58.0"
      
    }
  }
  # required_version = "~> 0.14"
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("service-account.json")
}

