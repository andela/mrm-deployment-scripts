# This resource sets up the storage for redis
resource "kubernetes_storage_class" "redis_storage" {
  metadata {
    name = "${var.storage_name}"  
  }
  storage_provisioner = "${var.storage_provisioner}"

}
resource "kubernetes_persistent_volume_claim" "redis_storage_claim" {
  metadata {
    name = "${var.storage_claim}"
    namespace = "${kubernetes_namespace.redis_namespace.id}"
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "${kubernetes_storage_class.redis_storage.metadata.0.name}"

    resources {
      requests {
        storage = "1Gi"
      }
    }
  }
}
