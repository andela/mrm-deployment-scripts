
resource "kubernetes_horizontal_pod_autoscaler" "frontend" {
  metadata {
    name      = "${var.frontend_name}"
    namespace = "${kubernetes_namespace.namespace.id}"
  }
  spec {
    max_replicas = 4
    min_replicas = 2
    target_cpu_utilization_percentage = "80"
    scale_target_ref {
      api_version = "extensions/v1beta1"
      kind = "Deployment"
      name = "${var.frontend_name}"
    }
  }
  depends_on = ["kubernetes_deployment.frontend"]
}
