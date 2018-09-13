resource "google_compute_instance_template" "frontend-template" {
  name                    = "${var.platform_name}-frontend-instance-template"
  description             = "Template used for frontend instances"
  instance_description    = "MRM Frontend Instance"
  machine_type            = "n1-standard-1"
  metadata_startup_script = "${lookup(var.startup_scripts,"frontend-server")}"

  disk {
    boot         = "true"
    source_image = "mrm-frontend-packer-image"
  }

  metadata {
    MRM_URL_SANDBOX        = "${var.mrm_url_sandbox}"
    MRM_API_URL_SANDBOX     = "${var.mrm_api_url_sandbox}"
    MRM_URL_STAGING         = "${var.mrm_url_staging}"
    MRM_API_URL_STAGING     = "${var.mrm_api_url_staging}"
    MRM_URL_PRODUCTION      = "${var.mrm_url_staging}"
    MRM_API_URL_PRODUCTION  = "${var.mrm_api_url_staging}"
    ANDELA_LOGIN_URL        = "${var.andela_login_url}"
    ANDELA_API_URL          = "${var.andela_api_url}"
    mrm_vault_server_IP     = "${lookup(var.static_ips, "vault-server")}"
    environment             = "${var.environment}"
    FIREBASE_API_KEY        = "${var.firebase_api_key}"
    FIREBASE_PROJECT_ID     = "${var.firebase_project_id}"
    FIREBASE_DATABASE_NAME  = "${var.firebase_database_name}"
    FIREBASE_BUCKET         = "${var.firebase_bucket}"
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
  name                    = "${var.platform_name}-backend-instance-template"
  description             = "Template used for backend instances"
  instance_description    = "MRM backend Instance"
  machine_type            = "n1-standard-1"
  metadata_startup_script = "${lookup(var.startup_scripts,"backend-server")}"

  disk {
    boot         = "true"
    source_image = "mrm-backend-packer-image"
  }

  metadata {
    APP_SETTINGS            = "${var.app_settings}"
    MRM_URL_SANDBOX        = "${var.mrm_url_sandbox}"
    MRM_API_URL_SANDBOX     = "${var.mrm_api_url_sandbox}"
    MRM_URL_STAGING         = "${var.mrm_url_staging}"
    MRM_API_URL_STAGING     = "${var.mrm_api_url_staging}"
    MRM_URL_PRODUCTION      = "${var.mrm_url_staging}"
    MRM_API_URL_PRODUCTION  = "${var.mrm_api_url_staging}"
    ANDELA_LOGIN_URL        = "${var.andela_login_url}"
    ANDELA_API_URL          = "${var.andela_api_url}"
    mrm_vault_server_IP     = "${lookup(var.static_ips, "vault-server")}"
    environment             = "${var.environment}"
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
