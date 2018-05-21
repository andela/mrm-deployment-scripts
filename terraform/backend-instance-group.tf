resource "google_compute_autoscaler" "backend-autoscaler" {
  name = "${var.platform-name}-backend-autoscaler"
  zone = "${var.gcloud-zone}"

  target = "${google_compute_instance_group_manager.backend-instance-group.self_link}"

  autoscaling_policy = {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 180

    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_instance_group_manager" "backend-instance-group" {
  name               = "${var.platform-name}-backend-instance-group"
  base_instance_name = "${var.platform-name}-backend-instance-group"
  instance_template  = "${google_compute_instance_template.backend-template.self_link}"
  zone               = "${var.gcloud-zone}"

  named_port {
    name = "http"
    port = 8000
  }

  depends_on = ["google_compute_instance.mrm-postgresql-instance", "google_compute_instance.mrm-vault-server-instance"]

  auto_healing_policies {
    health_check      = ""
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
        group = "${google_compute_instance_group_manager.backend-instance-group.instance_group}"
      },
    ]
  }

  backend_params = [
    "/mrm,http,8000,15",
  ]

  private_key = "${file("../secrets/star_andela_key.pem")}"
  certificate = "${file("../secrets/star_andela_cert.pem")}"
}
