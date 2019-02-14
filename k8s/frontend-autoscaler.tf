resource "kubernetes_horizontal_pod_autoscaler" "frontend" {
  metadata {
    name      = "${var.frontend_name}"
    namespace = "${kubernetes_namespace.namespace.id}"
  }
  spec {
    max_replicas = 4
    min_replicas = 2
    scale_target_ref {
      kind = "Deployment"
      name = "${var.frontend_name}"
    }
  }
}