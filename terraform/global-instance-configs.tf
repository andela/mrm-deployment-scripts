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
    environment             = "${var.vault_environment}"
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
      image = "https://www.googleapis.com/compute/v1/projects/learning-map-app/global/images/mrm-nat-gw-image"
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
