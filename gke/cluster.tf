resource "google_container_cluster" "converge_cluster" {
    name                = "converge-${var.environment}"
    zone                = "${var.zone}"
    network             = "${google_compute_network.converge_network.self_link}"
    subnetwork          = "${google_compute_subnetwork.converge_subnet.self_link}"
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
}

