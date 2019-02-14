resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "${var.frontend_name}"
    namespace = "${kubernetes_namespace.namespace.id}"
    labels {
      app     = "${var.frontend_name}"
    }
  }

  spec {
    replicas  = 2

    selector {
      match_labels {
        app         = "${var.frontend_name}"
      }
    }

    template {
      metadata {
        namespace   = "${kubernetes_namespace.namespace.id}"
        labels {
          app       =  "${var.frontend_name}"
        }
      }

      spec {
        container {
          image   = "${var.frontend_image}"
          name    = "${var.frontend_name}"
          port {
            container_port  = "${var.frontend_container_port}"
            name            = "http"
          }
          image_pull_policy = "Always"
          resources {
            requests {
              cpu     = "100m"
              memory  = "64Mi"
            }
            limits {
              cpu     = "100m"
              memory  = "64Mi"
            }
          }
          liveness_probe {
            http_get {
              path  = "/"
              port  = "http"
            }
            initial_delay_seconds  = "10"
          }

        }
      }
    }
  }
}