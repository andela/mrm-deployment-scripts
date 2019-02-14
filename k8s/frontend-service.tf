resource "kubernetes_service" "frontend" {
  metadata {
    name              = "${var.frontend_name}"
    namespace         = "${kubernetes_namespace.namespace.id}"
  }

  spec {
    selector {
      app               = "${kubernetes_deployment.frontend.metadata.0.labels.app}"
    }
    
    port {
        port            = "8080"
        target_port     = "http"
        name            = "http"
        protocol        = "TCP"
    }
    type              = "NodePort"
  }
}
