resource "google_compute_health_check" "backend-health-check" {
  name                = "${var.platform_name}-backend-autohealing-health-check"
  check_interval_sec  = 70
  timeout_sec         = 20
  healthy_threshold   = 2
  unhealthy_threshold = 10                                                      # 50 seconds

  http_health_check {
    request_path		= "/_healthcheck?query=%7B%0A%20%20rooms%7B%0A%20%20%20%20id%0A%20%20%7D%0A%7D"
    port         		= "8000"
  }
}

resource "google_compute_backend_service" "backend-lb-staging" {
  name        = "${var.platform_name}-backend-lb-staging"
  description = "MRM Backend Load Balancer"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 120
  enable_cdn  = false

  backend {
    group 		= "${google_compute_instance_group_manager.backend-instance-group-staging.instance_group}"
  }

  health_checks	= ["${google_compute_health_check.backend-health-check.self_link}"]
}

resource "google_compute_instance_group_manager" "backend-instance-group-staging" {
  name               = "${var.platform_name}-backend-instance-group-staging"
  base_instance_name = "${var.platform_name}-backend-instance-group-staging"
  instance_template  = "${google_compute_instance_template.backend-template-staging.self_link}"
  zone             = "${var.gcloud_zone}"
  update_strategy    = "NONE"
  
  named_port {
    name = "http"
    port = 8000
  }

  depends_on = ["google_compute_instance.mrm-vault-server-instance"]

  auto_healing_policies {
    health_check      = "${google_compute_health_check.backend-health-check.self_link}"
    initial_delay_sec = 300
  }
}

resource "google_compute_autoscaler" "backend-autoscaler-staging" {
  name				= "${var.platform_name}-backend-autoscaler-staging"
  zone 				= "${var.gcloud_zone}"
  target			= "${google_compute_instance_group_manager.backend-instance-group-staging.self_link}"
  autoscaling_policy = {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 200

    cpu_utilization {
      target = 0.7
    }
  }
}

resource "google_compute_backend_service" "backend-lb-prod" {
  name        = "${var.platform_name}-backend-lb-prod"
  description = "MRM Backend Load Balancer"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 120
  enable_cdn  = false
  count					  = 0

  backend {
    group = "${google_compute_instance_group_manager.backend-instance-group-prod.instance_group}"
  }

  health_checks = ["${google_compute_health_check.backend-health-check.self_link}"]
}

resource "google_compute_instance_group_manager" "backend-instance-group-prod" {
  name 				 = "${var.platform_name}-backend-instance-group-prod"
  base_instance_name = "${var.platform_name}-backend-instance-group-prod"
  instance_template  = "${google_compute_instance_template.backend-template-prod.self_link}"
  zone 				 = "${var.gcloud_zone}"
  update_strategy    = "NONE"
  count				 = 0
  
  named_port {
    name = "http"
    port = 8000
  }

  depends_on = ["google_compute_instance.mrm-vault-server-instance"]

  auto_healing_policies {
    health_check      = "${google_compute_health_check.backend-health-check.self_link}"
    initial_delay_sec = 300
  }
}

resource "google_compute_autoscaler" "backend-autoscaler-prod" {
  name 		= "${var.platform_name}-backend-autoscaler-prod"
  zone 		= "${var.gcloud_zone}"
  target 	= "${google_compute_instance_group_manager.backend-instance-group-prod.self_link}"
  count 	= 0
  autoscaling_policy = {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 200

    cpu_utilization {
      target = 0.7
    }
  }
}
