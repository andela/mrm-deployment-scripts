resource "google_compute_firewall" "firewall-allow-icmp-internal" {
  name        = "${var.platform_name}-allow-icmp-internal"
  description = "Allow ICMP between instances on the network"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "icmp"
  }

  source_ranges = ["${var.vpc_cidr}"]
}

resource "google_compute_firewall" "firewall-allow-logstash-elastic-internal" {
  name        = "${var.platform_name}-allow-logstash-internal"
  description = "Allow Connection between instances and logstash and elasticsearch on network"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["5044", "9200"]
  }

  source_ranges = ["${var.vpc_cidr}"]
}

resource "google_compute_firewall" "firewall-ssh-internal" {
  name        = "${var.platform_name}-allow-ssh-internal"
  description = "Allow ssh between instances on the network"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.vpc_cidr}"]
}

resource "google_compute_firewall" "firewall-ssh-gateway" {
  name        = "${var.platform_name}-allow-ssh-gateway"
  description = "Allow ssh between gateway instance and internet"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["nat-server"]
}

resource "google_compute_firewall" "firewall-allow-vault" {
  name        = "${var.platform_name}-allow-vault-private"
  description = "Allow port 8200 between specific instances"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["8200"]
  }

  source_ranges = ["${lookup(var.subnet_cidrs, "private-fe-be")}", "${lookup(var.subnet_cidrs, "private-db-va")}"]
  target_tags   = ["vault-server"]
}

resource "google_compute_firewall" "firewall-allow-postgres" {
  name        = "${var.platform_name}-allow-postgres-private"
  description = "Allow port 5432 between specific instances"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["${lookup(var.subnet_cidrs, "private-fe-be")}", "${lookup(var.subnet_cidrs, "private-db-va")}"]
  target_tags   = ["postgres-server"]
}

resource "google_compute_firewall" "firewall-allow-barman" {
  name        = "${var.platform_name}-allow-barman-private"
  description = "Allow port 41990 between specific instances"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["41990"]
  }

  source_ranges = ["${lookup(var.subnet_cidrs, "private-db-va")}"]
  target_tags   = ["postgres-server", "barman-server"]
}

resource "google_compute_firewall" "firewall-api-allow-http" {
  name        = "${var.platform_name}-allow-http-api"
  description = "Allow HTTP access across the firewall into the API Virtual Private Cloud."
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "8000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "firewall-allow-to-lb" {
  name        = "${var.platform_name}-allow-to-lb"
  description = "Allow HTTP access across the firewall into the API Virtual Private Cloud."
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["80", "8000", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["backend-server", "frontend-server"]
}

resource "google_compute_firewall" "firewall_api_allow_https" {
  name        = "${var.platform_name}-allow-https-api"
  description = "Allow HTTPS access across the firewall into the api Virtual Private Cloud."
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "firewall_elk_allow" {
  name        = "${var.platform_name}-allow-kibana-logstash"
  description = "Allow Kibana and Elasticsearch ports"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["5601", "9200"]
  }

  source_ranges = ["${var.vpc_cidr}"]
  target_tags   = ["sandbox-elk-server"]
}
