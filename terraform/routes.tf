resource "google_compute_route" "private-to-nat" {
  name                   = "${var.platform_name}-nat-route"
  dest_range             = "0.0.0.0/0"
  network                = "${google_compute_network.vpc.self_link}"
  next_hop_instance      = "${google_compute_instance.nat-gateway-instance.self_link}"
  next_hop_instance_zone = "europe-west1-b"
  priority               = 500
  tags                   = ["no-ip"]
}

resource "google_compute_global_forwarding_rule" "forward-http-fe" {
  name       = "${var.platform_name}-foward-http-fe"
  ip_address = "${google_compute_global_address.frontend-external-address.address}"
  target     = "${google_compute_target_http_proxy.http-proxy-fe.self_link}"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "http-proxy-fe" {
  name        = "${var.platform_name}-http-proxy-fe"
  url_map     = "${google_compute_url_map.url-map-fe.self_link}"
}
# End HTTP

# Begin HTTPS
resource "google_compute_global_forwarding_rule" "forward-https-fe" {
  name       = "${var.platform_name}-forward-https-fe"
  ip_address = "${google_compute_global_address.frontend-external-address.address}"
  target     = "${google_compute_target_https_proxy.mrm-https-proxy.self_link}"
  port_range = "443"
}

resource "google_compute_ssl_certificate" "mrm-ssl-certificate" {
  name_prefix = "mrm-certificate-"
  description = "MRM HTTPS certificate"
  private_key = "${file("../secrets/star_andela_key.pem")}"
  certificate = "${file("../secrets/star_andela_cert.pem")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_target_https_proxy" "mrm-https-proxy" {
  name = "${var.platform_name}-https-proxy-fe"
  url_map = "${google_compute_url_map.url-map-fe.self_link}"
  ssl_certificates = ["${google_compute_ssl_certificate.mrm-ssl-certificate.self_link}"]
}
# End HTTPS

resource "google_compute_url_map" "url-map-fe" {
  name            = "${var.platform_name}-url-map-fe"
  default_service = "${google_compute_backend_service.frontend-lb.self_link}"

  host_rule {
    hosts        = ["${google_compute_global_address.frontend-external-address.address}"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.frontend-lb.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.frontend-lb.self_link}"
    }
  }
}

resource "google_compute_global_forwarding_rule" "forward-http-be" {
  name       = "${var.platform_name}-foward-http-be"
  ip_address = "${google_compute_global_address.backend-external-address.address}"
  target     = "${google_compute_target_http_proxy.http-proxy-be.self_link}"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "http-proxy-be" {
  name        = "${var.platform_name}-http-proxy-be"
  url_map     = "${google_compute_url_map.url-map-be.self_link}"
}
# End HTTP

# Begin HTTPS
resource "google_compute_global_forwarding_rule" "forward-https-be" {
  name       = "${var.platform_name}-forward-https-be"
  ip_address = "${google_compute_global_address.backend-external-address.address}"
  target     = "${google_compute_target_https_proxy.https-proxy-be.self_link}"
  port_range = "443"
}

resource "google_compute_ssl_certificate" "mrm-ssl-certificate-be" {
  name_prefix = "mrm-certificate-be-"
  description = "MRM HTTPS certificate"
  private_key = "${file("../secrets/star_andela_key.pem")}"
  certificate = "${file("../secrets/star_andela_cert.pem")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_target_https_proxy" "https-proxy-be" {
  name = "${var.platform_name}-https-proxy-be"
  url_map = "${google_compute_url_map.url-map-be.self_link}"
  ssl_certificates = ["${google_compute_ssl_certificate.mrm-ssl-certificate-be.self_link}"]
}
# End HTTPS

resource "google_compute_url_map" "url-map-be" {
  name            = "${var.platform_name}-url-map-be"
  default_service = "${google_compute_backend_service.backend-lb.self_link}"

  host_rule {
    hosts        = ["${google_compute_global_address.backend-external-address.address}"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.backend-lb.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.backend-lb.self_link}"
    }
  }
}
