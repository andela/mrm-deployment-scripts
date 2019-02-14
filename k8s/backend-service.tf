resource "kubernetes_service" "backend" {
    metadata {
        name                = "${var.backend_name}"
		namespace 	        = "${kubernetes_namespace.namespace.id}"
    }

    spec {
        selector {
            app             = "${kubernetes_deployment.backend.metadata.0.labels.app}"
        }
        session_affinity    = "ClientIP"
        port {
            name            = "http"
            port            = "80"
            target_port     = "http"
            protocol        = "TCP"
        }

        type                = "NodePort"
    }
}
