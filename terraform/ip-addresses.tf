resource "google_compute_address" "ip-static-vault" {
  name         = "${var.platform-name}-vault-internal-ip"
  region       = "${var.gcloud-region}"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.private-db-va.self_link}"
  address      = "${lookup(var.static_ips, "vault-server")}"
}

resource "google_compute_address" "ip-static-postgresql" {
  name         = "${var.platform-name}-postgresql-internal-ip"
  region       = "${var.gcloud-region}"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.private-db-va.self_link}"
  address      = "${lookup(var.static_ips, "postgres-server")}"
}

resource "google_compute_address" "ip-static-barman" {
  name         = "${var.platform-name}-barman-server-internal-ip"
  region       = "${var.gcloud-region}"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.private-db-va.self_link}"
  address      = "${lookup(var.static_ips, "barman-server")}"
}

resource "google_compute_address" "ip-static-elk" {
  name         = "${var.platform-name}-elk-server-internal-ip"
  region       = "${var.gcloud-region}"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.public-subnet.self_link}"
  address      = "${lookup(var.static_ips, "elk-server")}"
}

resource "google_compute_address" "ip-ep-elk" {
  name   = "${var.platform-name}-elk-server-external-ip"
  region = "${var.gcloud-region}"
}
