resource "kubernetes_service" "slack_microservice" {
    metadata {
        name                = "${var.slack_microservice_name}"
		namespace 	        = "${kubernetes_namespace.namespace.id}"
    }

    spec {
        selector {
            app             = "${kubernetes_deployment.slack_microservice.metadata.0.labels.app}"
        }
        session_affinity    = "ClientIP"
        port {
            name            = "http"
            port            = "5500"
            target_port     = "http"
            protocol        = "TCP"
        }

        type                = "NodePort"
    }
}
