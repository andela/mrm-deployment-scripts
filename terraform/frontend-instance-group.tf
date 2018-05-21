resource "google_compute_autoscaler" "frontend-autoscaler" {
  name = "${var.platform-name}-frontend-autoscaler"
  zone = "${var.gcloud-zone}"

  target = "${google_compute_instance_group_manager.frontend-instance-group.self_link}"

  autoscaling_policy = {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 180

    cpu_utilization {
      target = 0.7
    }
  }
}

resource "google_compute_instance_group_manager" "frontend-instance-group" {
  name               = "${var.platform-name}-frontend-instance-group"
  base_instance_name = "${var.platform-name}-frontend-instance-group"
  instance_template  = "${google_compute_instance_template.frontend-template.self_link}"
  zone               = "${var.gcloud-zone}"

  named_port {
    name = "http"
    port = 80
  }

  depends_on = ["google_compute_instance.mrm-vault-server-instance"]

  auto_healing_policies {
    health_check      = ""
    initial_delay_sec = 300
  }
}

module "gce_lb_http_fe" {
  source            = "GoogleCloudPlatform/lb-http/google"
  name              = "${var.platform-name}-frontend-loadbalancer"
  target_tags       = ["public", "http-server", "https-server", "frontend-server"]
  firewall_networks = ["${google_compute_network.vpc.name}"]

  ssl = true

  backends = {
    "0" = [
      {
        group = "${google_compute_instance_group_manager.frontend-instance-group.instance_group}"
      },
    ]
  }

  backend_params = [
    "/,http,80,15",
  ]

  private_key = "${file("../secrets/star_andela_key.pem")}"
  certificate = "${file("../secrets/star_andela_cert.pem")}"
}
