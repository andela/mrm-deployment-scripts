// Configure project networks
resource "google_compute_network" "vpc" {
  name                    = "${var.platform-name}-vpc"
  description             = "Virtual Private Cloud for the MRM project"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "private-fe-be" {
  name          = "${var.platform-name}-private-fe-be"
  description   = "Private subnet for the backend and front end servers"
  ip_cidr_range = "${lookup(var.subnet-cidrs, "private-fe-be")}"
  network       = "${google_compute_network.vpc.self_link}"
}

resource "google_compute_subnetwork" "private-db-va" {
  name          = "${var.platform-name}-private-db-va"
  description   = "Private subnet for the vaults and postgres servers"
  ip_cidr_range = "${lookup(var.subnet-cidrs, "private-db-va")}"
  network       = "${google_compute_network.vpc.self_link}"
}

resource "google_compute_subnetwork" "public-subnet" {
  name          = "${var.platform-name}-public"
  description   = "Public subnet for the MRM project"
  ip_cidr_range = "${lookup(var.subnet-cidrs, "public")}"
  network       = "${google_compute_network.vpc.self_link}"
}
