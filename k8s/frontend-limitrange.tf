resource "kubernetes_limit_range" "frontend" {
    metadata {
        name = "${var.frontend_name}"
        namespace = "${kubernetes_namespace.namespace.id}"
    }
    spec {
        limit {
            type = "Pod"

            min {
               cpu = "50m"
               memory = "24Mi"
            }
            max {
                cpu = "2"
                memory = "1.4Gi"
            }
        }
        limit {
            type = "PersistentVolumeClaim"
            min {
                storage = "24M"
            }
        }
        limit {
            type = "Container"
            default {
                cpu = "300m"
                memory = "512Mi"
            }
            default_request {
               cpu = "100m"
               memory = "256Mi"
            }
            min {
              cpu = "100m"
              memory = "24Mi"
            }
            max {
              cpu = "2"
              memory = "1.4Gi"
            }
        }
    }
}