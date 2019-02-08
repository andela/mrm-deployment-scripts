provider "google" {
    credentials         = "${var.credentials}"
    project             = "${var.project}"
    region              = "${var.region}"
    zone                = "${var.zone}"
}

terraform {
    backend "gcs" {}
}

data "terraform_remote_state" "converge" {
    backend = "gcs"

    config {
        bucket          = "${var.bucket}"
        prefix          = "${var.prefix}"
        project         = "${var.project}"
        credentials     = "${var.credentials}"
    }
}
