resource "kubernetes_namespace" "namespace" {
  metadata {
    name    = "${var.namespace}"
  }
}

resource "kubernetes_namespace" "microservice_namespace" {
  metadata {
    name    = "${var.microservice_namespace}" 
  }
}
