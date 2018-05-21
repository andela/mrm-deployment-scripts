resource "google_compute_route" "private-to-nat" {
  name                   = "${var.platform-name}-nat-route"
  dest_range             = "0.0.0.0/0"
  network                = "${google_compute_network.vpc.self_link}"
  next_hop_instance      = "${google_compute_instance.nat-gateway-instance.self_link}"
  next_hop_instance_zone = "europe-west1-b"
  priority               = 500
  tags                   = ["no-ip"]
}
