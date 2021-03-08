# Provision a container registry in the EU
# This will mean we tag images to eu.gcr.io such as:
# docker tag devops-bookstore-api:1.0 eu.gcr.io/PROJECT-ID/devops-bookstore-api:1.0
resource "google_container_registry" "devops-upskill-registry" {
  location = "EU"
}