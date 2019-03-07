resource "kubernetes_deployment" "microservice" {
    metadata {
        name        = "${var.microservice_name}"
        namespace   = "${kubernetes_namespace.namespace.id}"
        labels {
            app     = "${var.microservice_name}"
        }
    }

    spec {
        replicas    = 3

        selector {
            match_labels {
                app = "${var.microservice_name}"
            }
        }

        template {
            metadata {
                namespace       = "${kubernetes_namespace.namespace.id}"
                labels {
                    app         = "${var.microservice_name}"
                }
            }

            spec {
                container {
                    image               = "${var.microservice_image}"
                    name                = "${var.microservice_name}"
                    port {
                        container_port  = "${var.microservice_container_port}"
                        name            = "http"
                    }
                    
                    image_pull_policy 	= "Always"
                    command             = ["/usr/bin/supervisord"]
                }
            }
        }
    }
}
