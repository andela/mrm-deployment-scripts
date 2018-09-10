resource "google_compute_address" "ip-static-vault" {
  name         = "${var.platform_name}-vault-internal-ip"
  region       = "${var.gcloud_region}"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.private-db-va.self_link}"
  address      = "${lookup(var.static_ips, "vault-server")}"
}

resource "google_compute_address" "ip-static-postgresql" {
  name         = "${var.platform_name}-postgresql-internal-ip"
  region       = "${var.gcloud_region}"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.private-db-va.self_link}"
  address      = "${lookup(var.static_ips, "postgres-server")}"
}

resource "google_compute_address" "ip-static-redis" {
  name         = "${var.platform_name}-redis-internal-ip"
  region       = "${var.gcloud_region}"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.private-db-va.self_link}"
  address      = "${lookup(var.static_ips, "redis-server")}"
}

resource "google_compute_address" "ip-static-barman" {
  name         = "${var.platform_name}-barman-server-internal-ip"
  region       = "${var.gcloud_region}"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.private-db-va.self_link}"
  address      = "${lookup(var.static_ips, "barman-server")}"
}

resource "google_compute_address" "ip-static-elk" {
  name         = "${var.platform_name}-elk-server-internal-ip"
  region       = "${var.gcloud_region}"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.public-subnet.self_link}"
  address      = "${lookup(var.static_ips, "elk-server")}"
}

resource "google_compute_address" "ip-ep-elk" {
  name   = "${var.platform_name}-elk-server-external-ip"
  region = "${var.gcloud_region}"
}

