resource "google_container_cluster" "converge_cluster" {
  name                     = "converge-${var.environment}"
  location                 = "${var.zone}"
  network                  = "${google_compute_network.converge_network.self_link}"
  subnetwork               = "${google_compute_subnetwork.converge_subnet.self_link}"
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "converge_node_pool" {
  name       = "default-pool"
  location   = "${var.zone}"
  cluster    = "${google_container_cluster.converge_cluster.name}"
  node_count = 3

  autoscaling {
    min_node_count = 3
    max_node_count = 6
  }

  management {
    auto_upgrade = true
  }

  node_config {
    machine_type = "g1-small"
    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute"
    ]
  }
}
