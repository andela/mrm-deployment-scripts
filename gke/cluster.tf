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
    node_config {
        machine_type = "g1-small"
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
