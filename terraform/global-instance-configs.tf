resource "google_compute_instance" "mrm-vault-server-instance" {
  name                    = "${var.platform_name}-vault-server"
  description             = "For help with secret management"
  machine_type            = "n1-standard-1"
  allow_stopping_for_update = true
  zone                    = "${var.gcloud_zone}"
  metadata_startup_script = "${lookup(var.startup_scripts, "vault-server")}"

  boot_disk {
    initialize_params {
      image = "mrm-vault-image"
    }
  }

  metadata {
    environment         = "${var.environment}"
  }


  tags = ["vault-server", "no-ip"]

  network_interface {
    subnetwork = "${google_compute_subnetwork.private-db-va.self_link}"
    address    = "${google_compute_address.ip-static-vault.address}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "nat-gateway-instance" {
  name                    = "${var.platform_name}-nat-gateway-server"
  description             = "nat instance"
  machine_type            = "g1-small"
  zone                    = "${var.gcloud_zone}"
  metadata_startup_script = "${lookup(var.startup_scripts, "nat-server")}"

  boot_disk {
    initialize_params {
      image = "mrm-nat-gateway-image"
    }
  }

  tags = ["nat-server", "public", "nat", "http-server", "https-server"]

  network_interface {
    subnetwork = "${google_compute_subnetwork.public-subnet.self_link}"

    access_config {}
  }

  can_ip_forward = "true"

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "mrm-elk-server" {
  name         = "${var.platform_name}-elk-server"
  description  = "mrm ELK monitoring server"
  machine_type = "n1-standard-2"
  zone         = "${var.gcloud_zone}"

  boot_disk {
    initialize_params {
      image = "mrm-elk-image"
      size  = "100"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.public-subnet.self_link}"
    address    = "${google_compute_address.ip-static-elk.address}"

    access_config {
      nat_ip = "${google_compute_address.ip-ep-elk.address}"
    }
  }

  tags = ["elk-server", "public", "http-server", "https-server"]

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "mrm-postgresql-instance" {
  name                      = "${var.platform_name}-postgresql-server"
  description               = "System Database"
  machine_type              = "n1-standard-1"
  zone                      = "${var.gcloud_zone}"
  metadata_startup_script   = "${lookup(var.startup_scripts, "postgres-server")}"

  boot_disk {
    initialize_params {
      image = "mrm-postgres-image"
    }
  }
  
  metadata {
    environment               = "${var.environment}"
  }

  tags = ["postgresql-server", "no-ip", "postgres-server"]

  network_interface {
    subnetwork = "${google_compute_subnetwork.private-db-va.self_link}"
    address    = "${google_compute_address.ip-static-postgresql.address}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "mrm-redis-instance" {
  name                      = "${var.platform_name}-redis-server"
  description               = "Redis Database"
  machine_type              = "n1-standard-1"
  zone                      = "${var.gcloud_zone}"
  metadata_startup_script   = "${lookup(var.startup_scripts, "redis-server")}"

  boot_disk {
    initialize_params {
      image = "mrm-redis-image"
    }
  }
  
  metadata {
    environment               = "${var.environment}"
  }

  tags = ["redis-server", "no-ip"]

  network_interface {
    subnetwork = "${google_compute_subnetwork.private-db-va.self_link}"
    address    = "${google_compute_address.ip-static-redis.address}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "mrm-barman-instance" {
  name         = "${var.platform_name}-barman-server"
  description  = "Backup Server for Postgres Instance"
  machine_type = "n1-standard-1"
  zone         = "${var.gcloud_zone}"

  boot_disk {
    initialize_params {
      image = "mrm-barman-image"
    }
  }

  tags       = ["barman-server", "no-ip"]
  depends_on = ["google_compute_instance.mrm-postgresql-instance"]

  network_interface {
    subnetwork = "${google_compute_subnetwork.private-db-va.self_link}"
    address    = "${google_compute_address.ip-static-barman.address}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}
