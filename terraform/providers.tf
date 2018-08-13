provider "google" {
  credentials = "${file("google-creds.json")}"
  project     = "${var.gcloud_project}"
  region      = "${var.gcloud_region}"
}

terraform {
  backend "gcs" {}
}

data "terraform_remote_state" "mrm" {
  backend = "gcs"

  config {
    bucket      = "${var.bucket}"
    prefix      = "terraform/state"
    project     = "${var.gcloud_project}"
    credentials = "${file("google-creds.json")}"
  }
}
