# This resource deploys a redis cluster using a stateful set
resource "kubernetes_stateful_set" "redis_master" {
  metadata {
    name      = "converge-redis"
    namespace = "${kubernetes_namespace.redis_namespace.id}"
  }

  spec {
    selector {
            match_labels {
                app = "converge-redis"
            } 
    }

    service_name = "${var.service_name}"
    replicas = 4 

    template {
      metadata {
        labels {
          app  = "converge-redis"
        }
      }
      spec {
        termination_grace_period_seconds = 10
        container {
          name              = "converge-redis"
          image             = "${var.service_image}"
          image_pull_policy = "Always"
          args              = ["/etc/redis/redis.conf"]
          port {
            name           = "redis"
            container_port = "${var.master_port}"
          }

          liveness_probe {
            initial_delay_seconds = "${var.master_liveness_probe["initial_delay_seconds"]}"
            period_seconds        = "${var.master_liveness_probe["period_seconds"]}"
            timeout_seconds       = "${var.master_liveness_probe["timeout_seconds"]}"
            success_threshold     = "${var.master_liveness_probe["success_threshold"]}"
            failure_threshold     = "${var.master_liveness_probe["failure_threshold"]}"

            exec {
              command = [
                "redis-cli",
                "ping",
              ]
            }
          }
           resources{
            limits{
              cpu    = "150m"
              memory = "256Mi"
            }
            requests{
              cpu    = "50m"
              memory = "128Mi"
            }
          }
          volume_mount {
            name       = "${var.config_name}"
            mount_path = "${var.mount_path}"
            read_only  = "false"
          }
           volume_mount {
            name       = "${var.storage_name}"
            mount_path = "/data"
            read_only  = "false"
          }
        }
        volume {
          name = "${var.config_name}"
          config_map{
            name = "${var.config_name}"
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "${var.storage_name}"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests {
            storage = "1Gi"
          }
        }
      }
    }
  }
}
