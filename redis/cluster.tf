resource "google_container_cluster" "converge_redis_cluster" {
  name                  = "coverge-redis-cluster"
  zone                  = "europe-west1-b"
  initial_node_count    = 2
  network               = "${google_compute_network.converge_redis_network.self_link}"
  subnetwork            = "${google_compute_subnetwork.converge_redis_subnet.self_link}"

  master_auth {
    username            = "apprenticeshipadmin"
    password            = "${var.cluster_master_password}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      project_name      = "apprenticeship"
      product           = "${var.product_tag}"
      component         = "redis"
      env               = "production"
      state             = "in-use"
    }

    tags = ["converge-redis", "redis"]
  }
}
