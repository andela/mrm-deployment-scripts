resource "google_compute_instance_template" "frontend-template-staging" {
  name_prefix             = "${var.platform_name}-frontend-template-staging-"
  description             = "Template used for frontend instances"
  instance_description    = "MRM Frontend Instance"
  machine_type            = "n1-standard-1"
  metadata_startup_script = "${lookup(var.startup_scripts,"frontend-server")}"

  disk {
    boot         = "true"
    source_image = "${var.frontend_image_url}"
  }

  metadata {
    MRM_URL_SANDBOX         = "${var.mrm_url_sandbox}"
    MRM_API_URL_SANDBOX     = "${var.mrm_api_url_sandbox}"
    MRM_URL_STAGING         = "${var.mrm_url_staging}"
    MRM_API_URL_STAGING     = "${var.mrm_api_url_staging}"
    MRM_URL_PRODUCTION      = "${var.mrm_url_production}"
    MRM_API_URL_PRODUCTION  = "${var.mrm_api_url_production}"
    ANDELA_LOGIN_URL        = "${var.andela_login_url}"
    ANDELA_API_URL          = "${var.andela_api_url}"
    mrm_vault_server_IP     = "${lookup(var.static_ips, "vault-server")}"
    environment             = "${var.template_environment}"
    FIREBASE_API_KEY        = "${var.firebase_api_key}"
    FIREBASE_PROJECT_ID     = "${var.firebase_project_id}"
    FIREBASE_DATABASE_NAME  = "${var.firebase_database_name}"
    FIREBASE_BUCKET         = "${var.firebase_bucket}"
    BASE_URL                = "${var.base_url}"
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

resource "google_compute_instance_template" "frontend-template-prod" {
  name_prefix             = "${var.platform_name}-frontend-template-"
  description             = "Template used for frontend instances"
  instance_description    = "MRM Frontend Instance"
  machine_type            = "n1-standard-1"
  metadata_startup_script = "${lookup(var.startup_scripts,"frontend-server")}"

  disk {
    boot         = "true"
    source_image = "${var.frontend_image_url}"
  }

  metadata {
    MRM_URL_SANDBOX         = "${var.mrm_url_sandbox}"
    MRM_API_URL_SANDBOX     = "${var.mrm_api_url_sandbox}"
    MRM_URL_STAGING         = "${var.mrm_url_staging}"
    MRM_API_URL_STAGING     = "${var.mrm_api_url_staging}"
    MRM_URL_PRODUCTION      = "${var.mrm_url_production}"
    MRM_API_URL_PRODUCTION  = "${var.mrm_api_url_production}"
    ANDELA_LOGIN_URL        = "${var.andela_login_url}"
    ANDELA_API_URL          = "${var.andela_api_url}"
    mrm_vault_server_IP     = "${lookup(var.static_ips, "vault-server")}"
    environment             = "production"
    FIREBASE_API_KEY        = "${var.firebase_api_key}"
    FIREBASE_PROJECT_ID     = "${var.firebase_project_id}"
    FIREBASE_DATABASE_NAME  = "${var.firebase_database_name}"
    FIREBASE_BUCKET         = "${var.firebase_bucket}"
    BASE_URL                = "${var.base_url}"
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

resource "google_compute_instance_template" "backend-template-staging" {
  name_prefix             = "${var.platform_name}-backend-template-staging-"
  description             = "Template used for backend instances"
  instance_description    = "MRM backend Instance"
  machine_type            = "n1-standard-1"
  metadata_startup_script = "${lookup(var.startup_scripts,"backend-server")}"

  disk {
    boot         = "true"
    source_image = "${var.backend_image_url}"
  }

  metadata {
    APP_SETTINGS            = "${var.app_settings}"
    MRM_URL_SANDBOX         = "${var.mrm_url_sandbox}"
    MRM_API_URL_SANDBOX     = "${var.mrm_api_url_sandbox}"
    MRM_URL_STAGING         = "${var.mrm_url_staging}"
    MRM_API_URL_STAGING     = "${var.mrm_api_url_staging}"
    MRM_URL_PRODUCTION      = "${var.mrm_url_production}"
    MRM_API_URL_PRODUCTION  = "${var.mrm_api_url_production}"
    ANDELA_LOGIN_URL        = "${var.andela_login_url}"
    ANDELA_API_URL          = "${var.andela_api_url}"
    mrm_vault_server_IP     = "${lookup(var.static_ips, "vault-server")}"
    environment             = "${var.template_environment}"
    MRM_PUSH_URL            = "${var.push_url}"
    API_KEY                 = "${var.backend_api_key}"
    OOATH2_CLIENT_ID        = "${var.backend_oath_client_id}"
    OOATH2_CLIENT_SECRET    = "${var.backend_oath_client_secret}"
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

resource "google_compute_instance_template" "backend-template-prod" {
  name_prefix             = "${var.platform_name}-backend-template-"
  description             = "Template used for backend instances"
  instance_description    = "MRM backend Instance"
  machine_type            = "n1-standard-1"
  metadata_startup_script = "${lookup(var.startup_scripts,"backend-server")}"

  disk {
    boot         = "true"
    source_image = "${var.backend_image_url}"
  }

  metadata {
    APP_SETTINGS            = "${var.app_settings}"
    MRM_URL_SANDBOX         = "${var.mrm_url_sandbox}"
    MRM_API_URL_SANDBOX     = "${var.mrm_api_url_sandbox}"
    MRM_URL_STAGING         = "${var.mrm_url_staging}"
    MRM_API_URL_STAGING     = "${var.mrm_api_url_staging}"
    MRM_URL_PRODUCTION      = "${var.mrm_url_production}"
    MRM_API_URL_PRODUCTION  = "${var.mrm_api_url_production}"
    ANDELA_LOGIN_URL        = "${var.andela_login_url}"
    ANDELA_API_URL          = "${var.andela_api_url}"
    mrm_vault_server_IP     = "${lookup(var.static_ips, "vault-server")}"
    environment             = "production"
    MRM_PUSH_URL            = "${var.push_url}"
    API_KEY                 = "${var.backend_api_key}"
    OOATH2_CLIENT_ID        = "${var.backend_oath_client_id}"
    OOATH2_CLIENT_SECRET    = "${var.backend_oath_client_secret}"
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
