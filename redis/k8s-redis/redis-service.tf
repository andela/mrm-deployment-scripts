# This resource configures the redis service
resource "kubernetes_service" "redis_service" {

  metadata {
    name      = "${var.service_name}"
    namespace = "${kubernetes_namespace.redis_namespace.id}"

    labels {
      app     = "converge-redis"
    }
  }

  spec {

    port {
      name        = "server-port"
      port        = 6379
      protocol    = "TCP"
      target_port = 6379
    }
    cluster_ip  = "None"

    selector {     
        "statefulset.kubernetes.io/pod-name" = "converge-redis-0"    
    }
  }
}
