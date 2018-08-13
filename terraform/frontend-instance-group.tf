resource "google_compute_health_check" "frontend-health-check" {
  name                = "${var.platform_name}-frontend-autohealing-health-check"
  check_interval_sec  = 70
  timeout_sec         = 20
  healthy_threshold   = 2
  unhealthy_threshold = 10                                                       # 50 seconds

  http_health_check {
    request_path = "/health-check"
    port         = "80"
  }
}

resource "google_compute_region_autoscaler" "frontend-autoscaler" {
  name   = "${var.platform_name}-frontend-autoscaler"
  region = "${var.gcloud_region}"

  target = "${google_compute_region_instance_group_manager.frontend-instance-group.self_link}"

  autoscaling_policy = {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 180

    cpu_utilization {
      target = 0.7
    }
  }
}

resource "google_compute_region_instance_group_manager" "frontend-instance-group" {
  name               = "${var.platform_name}-frontend-instance-group"
  base_instance_name = "${var.platform_name}-frontend-instance-group"
  instance_template  = "${google_compute_instance_template.frontend-template.self_link}"
  region             = "${var.gcloud_region}"

  named_port {
    name = "http"
    port = 80
  }

  depends_on = ["google_compute_instance.mrm-vault-server-instance"]

  auto_healing_policies {
    health_check      = "${google_compute_health_check.frontend-health-check.self_link}"
    initial_delay_sec = 300
  }
}

module "gce_lb_http_fe" {
  source            = "GoogleCloudPlatform/lb-http/google"
<<<<<<< HEAD
  name              = "${var.platform-name}-frontend-lb"
=======
  name              = "${var.platform_name}-frontend-lb"
>>>>>>> [ch #159428898] modify variable definition to underscore
  target_tags       = ["public", "http-server", "https-server", "frontend-server"]
  firewall_networks = ["${google_compute_network.vpc.name}"]

  ssl = true

  backends = {
    "0" = [
      {
        group = "${google_compute_region_instance_group_manager.frontend-instance-group.instance_group}"
      },
    ]
  }

  backend_params = [
    "/health-check,http,80,15",
  ]

  private_key = "${file("../secrets/star_andela_key.pem")}"
  certificate = "${file("../secrets/star_andela_cert.pem")}"
}
