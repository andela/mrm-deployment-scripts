resource "kubernetes_horizontal_pod_autoscaler" "backend" {
  metadata {
    name      = "${var.backend_name}"
    namespace = "${kubernetes_namespace.namespace.id}"
  }
  spec {
    max_replicas = 4
    min_replicas = 2
    scale_target_ref {
      kind = "Deployment"
      name = "${var.backend_name}"
    }
  }
}