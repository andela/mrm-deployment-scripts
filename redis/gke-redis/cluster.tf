# resource that defines the redis cluster
resource "google_container_cluster" "converge_redis_cluster" {
    name                = "${var.name}"
    location            = "${var.zone}"
    network             = "${google_compute_network.converge_redis_network.self_link}"
    subnetwork          = "${google_compute_subnetwork.converge_redis_subnet.self_link}"
    node_pool           = [{
        name            = "default-pool"
        node_count      = 2

        autoscaling {
            min_node_count      = 2
            max_node_count      = 5
        }

        management {
            auto_upgrade        = true
        }
    }]
     master_auth {
    username = "${var.username}"
    password = "${var.password}"

    client_certificate_config {
      issue_client_certificate = false
    }
  }
 
}
