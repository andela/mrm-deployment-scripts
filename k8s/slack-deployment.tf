resource "kubernetes_deployment" "slack_microservice" {
    metadata {
        name        = "${var.slack_microservice_name}"
        namespace   = "${kubernetes_namespace.namespace.id}"
        labels {
            app     = "${var.slack_microservice_name}"
        }
    }

    spec {
        replicas    = 3

        selector {
            match_labels {
                app = "${var.slack_microservice_name}"
            }
        }

        template {
            metadata {
                namespace       = "${kubernetes_namespace.namespace.id}"
                labels {
                    app         = "${var.slack_microservice_name}"
                }
            }

            spec {
                container {
                    image               = "${var.slack_microservice_image}"
                    name                = "${var.slack_microservice_name}"
                    port {
                        container_port  = "${var.slack_microservice_container_port}"
                        name            = "http"
                    }

                    image_pull_policy 	= "Always"
                    # command             = ["/bin/bash", "jenkins/scripts/start_app.sh"]
                }
            }
        }
    }
}
