resource "google_compute_health_check" "backend-health-check" {
  name                = "${var.platform-name}-backend-autohealing-health-check"
  check_interval_sec  = 70
  timeout_sec         = 20
  healthy_threshold   = 2
  unhealthy_threshold = 10                                                      # 50 seconds

  http_health_check {
    request_path = "/_healthcheck?query=%7B%0A%20%20rooms%7B%0A%20%20%20%20id%0A%20%20%7D%0A%7D"
    port         = "8000"
  }
}

resource "google_compute_region_autoscaler" "backend-autoscaler" {
  name   = "${var.platform-name}-backend-autoscaler"
  region = "${var.gcloud-region}"

  target = "${google_compute_region_instance_group_manager.backend-instance-group.self_link}"

  autoscaling_policy = {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 200

    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_region_instance_group_manager" "backend-instance-group" {
  name               = "${var.platform-name}-backend-instance-group"
  base_instance_name = "${var.platform-name}-backend-instance-group"
  instance_template  = "${google_compute_instance_template.backend-template.self_link}"
  region             = "${var.gcloud-region}"

  named_port {
    name = "http"
    port = 8000
  }

  depends_on = ["google_compute_instance.mrm-postgresql-instance", "google_compute_instance.mrm-vault-server-instance"]

  auto_healing_policies {
    health_check      = "${google_compute_health_check.backend-health-check.self_link}"
    initial_delay_sec = 300
  }
}

module "gce_lb_http_be" {
  source            = "GoogleCloudPlatform/lb-http/google"
  name              = "${var.platform-name}-backend-loadbalancer"
  target_tags       = ["public", "http-server", "https-server", "backend-server"]
  firewall_networks = ["${google_compute_network.vpc.name}"]

  ssl = true

  backends = {
    "0" = [
      {
        group = "${google_compute_region_instance_group_manager.backend-instance-group.instance_group}"
      },
    ]
  }

  backend_params = [
    "/_healthcheck?query=%7B%0A%20%20rooms%7B%0A%20%20%20%20id%0A%20%20%7D%0A%7D,http,8000,15",
  ]

  private_key = "${file("../secrets/star_andela_key.pem")}"
  certificate = "${file("../secrets/star_andela_cert.pem")}"
}
