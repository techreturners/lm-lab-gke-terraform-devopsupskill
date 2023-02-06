terraform {
  required_providers {
    google = {
      source      = "hashicorp/google"
      version     = "4.52.0"
      
    }
  }
  required_version = ">= 1.3.0"
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("service-account.json")
}

