# This resource configures the ingress of the redis service
resource "kubernetes_ingress" "redis_ingress" {
  metadata {
    name = "${var.ingress_name}"
    namespace = "${kubernetes_namespace.redis_namespace.id}"
    annotations {
        "kubernetes.io/ingress.class" = "nginx"
        "nginx.ingress.kubernetes.io/force-ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      http {
        path {

          path = "/"
          backend {
            service_name = "${var.service_name}"
            service_port = "server-port"
          }
        }
      }
      host = "${var.host_name}"
    }

  }
}
