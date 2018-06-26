resource "google_compute_instance_template" "frontend-template" {
  name                    = "${var.platform-name}-frontend-instance-template"
  description             = "Template used for frontend instances"
  instance_description    = "MRM Frontend Instance"
  machine_type            = "n1-standard-1"
  metadata_startup_script = "${lookup(var.startup_scripts,"frontend-server")}"

  disk {
    boot         = "true"
    source_image = "mrm-frontend-packer-image"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.private-fe-be.self_link}"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = ["no-ip", "frontend-server"]

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_template" "backend-template" {
  name                    = "${var.platform-name}-backend-instance-template"
  description             = "Template used for backend instances"
  instance_description    = "MRM backend Instance"
  machine_type            = "n1-standard-1"
  metadata_startup_script = "${lookup(var.startup_scripts,"backend-server")}"

  disk {
    boot         = "true"
    source_image = "mrm-backend-packer-image"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.private-fe-be.self_link}"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = ["no-ip", "backend-server"]

  service_account {
    scopes = ["cloud-platform"]
  }
}
