resource "kubernetes_secret" "backend_secrete" {
    metadata {
        name            = "cloudsql-instance-credentials"
        namespace       = "${kubernetes_namespace.namespace.id}"
        labels {
            app         = "${var.backend_name}"
        }
    }
    type                = "Opaque"
    data {
        credentials.json = "${file("${var.credentials_file}")}"
    }
}
