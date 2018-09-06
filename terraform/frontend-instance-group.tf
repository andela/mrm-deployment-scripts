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

resource "google_compute_backend_service" "frontend-lb" {
  name        = "${var.platform_name}-frontend-lb"
  description = "MRM Frontend Load Balancer"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 120
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group_manager.frontend-instance-group.instance_group}"
  }

  session_affinity = "GENERATED_COOKIE"

  health_checks = ["${google_compute_health_check.frontend-health-check.self_link}"]
}

resource "google_compute_instance_group_manager" "frontend-instance-group" {
  name               = "${var.platform_name}-frontend-instance-group"
  base_instance_name = "${var.platform_name}-frontend-instance-group"
  instance_template  = "${google_compute_instance_template.frontend-template.self_link}"
  zone             = "${var.gcloud_zone}"
  update_strategy    = "NONE"
  
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

resource "google_compute_autoscaler" "frontend-autoscaler" {
  name   = "${var.platform_name}-frontend-autoscaler"
  zone = "${var.gcloud_zone}"
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
