# resource that defines the redis network
resource "google_compute_network" "converge_redis_network" {
    name                    = "${var.name}-vpc"
    auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "converge_redis_subnet" {
    name                        = "${var.name}-subnet"
    ip_cidr_range               = "192.168.0.0/16"
    region                      = "${var.region}"
    network                     = "${google_compute_network.converge_redis_network.self_link}"
    private_ip_google_access    = "true"
}
