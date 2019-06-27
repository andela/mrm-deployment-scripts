# This resource configures the namespace in which the redis cluster will be located
resource "kubernetes_namespace" "redis_namespace" {
  metadata {
    annotations {
      name = "${var.namespace}"
    }

    labels {
      mylabel = "converge-redis-namespace"
    }

    name = "${var.namespace}"
  }
}
