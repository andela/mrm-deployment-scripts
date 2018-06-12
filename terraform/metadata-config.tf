// Setup all project-wide metadata.

resource "google_compute_project_metadata" "mrm_api_project_metadata" {
  metadata {
    mrm_vault_server_IP = "${lookup(var.static_ips, "vault-server")}"
  }
}
