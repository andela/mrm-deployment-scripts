resource "google_compute_firewall" "firewall-allow-icmp-internal" {
  name        = "${var.platform-name}-allow-icmp-internal"
  description = "Allow ICMP between instances on the network"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "icmp"
  }

  source_ranges = ["172.16.0.0/16"]
}

resource "google_compute_firewall" "firewall-allow-logstash-elastic-internal" {
  name        = "${var.platform-name}-allow-logstash-internal"
  description = "Allow Connection between instances and logstash and elasticsearch on network"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["5044", "9200"]
  }

  source_ranges = ["172.16.0.0/16"]
}

resource "google_compute_firewall" "firewall-ssh-internal" {
  name        = "${var.platform-name}-allow-ssh-internal"
  description = "Allow ssh between instances on the network"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["172.16.0.0/16"]
}

resource "google_compute_firewall" "firewall-ssh-gateway" {
  name        = "${var.platform-name}-allow-ssh-gateway"
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
  name        = "${var.platform-name}-allow-vault-private"
  description = "Allow port 8200 between specific instances"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["8200"]
  }

  source_ranges = ["172.16.1.0/24", "172.16.13.0/24"]
  target_tags   = ["vault-server"]
}

resource "google_compute_firewall" "firewall-allow-postgres" {
  name        = "${var.platform-name}-allow-postgres-private"
  description = "Allow port 5432 between specific instances"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["172.16.1.0/24", "172.16.13.0/24"]
  target_tags   = ["postgres-server"]
}

resource "google_compute_firewall" "firewall-allow-barman" {
  name        = "${var.platform-name}-allow-barman-private"
  description = "Allow port 41990 between specific instances"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["41990"]
  }

  source_ranges = ["172.16.13.0/24"]
  target_tags   = ["postgres-server", "barman-server"]
}

resource "google_compute_firewall" "firewall-api-allow-http" {
  name        = "${var.platform-name}-allow-http-api"
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
  name        = "${var.platform-name}-allow-to-lb"
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
  name        = "${var.platform-name}-allow-https-api"
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
  name        = "${var.platform-name}-allow-kibana-logstash"
  description = "Allow Kibana and Elasticsearch ports"
  network     = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["5601", "9200"]
  }

  source_ranges = ["172.16.0.0/16"]
  target_tags   = ["sandbox-elk-server"]
}
