provider "google" {
  credentials = "${file("google-creds.json")}"
  project     = "${var.gcloud-project}"
  region      = "${var.gcloud-region}"
}

# terraform {
#   backend "gcs" {}
# }


# data "terraform_remote_state" "mrm" {
#   backend = "gcs"


#   config {
#     bucket      = "${var.bucket}"
#     prefix      = "terraform/state"
#     project     = "${var.gcloud-project}"
#     credentials = "${file("google-cred.json")}"
#   }
# }

