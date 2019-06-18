# This resource sets up the redis load balancer service
resource "kubernetes_service" "load_balancer" {
   depends_on = [
       "null_resource.ingress_controller",
  ]
  metadata {
    name = "ingress-nginx"
    namespace = "ingress-nginx"
    labels {
        "app.kubernetes.io/name" = "ingress-nginx"
        "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }
  spec {
      external_traffic_policy = "Local"
      type = "LoadBalancer"
      load_balancer_ip = "${var.regional_static_ip}"
    selector {
      "app.kubernetes.io/name" = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
    port {
      name = "redis"
      port = 6379
      target_port = "redis"
    }
  }
}
