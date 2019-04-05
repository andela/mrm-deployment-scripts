resource "kubernetes_deployment" "backend" {
    metadata {
        name        = "${var.backend_name}"
        namespace   = "${kubernetes_namespace.namespace.id}"
        labels {
            app     = "${var.backend_name}"
        }
    }

    spec {
        replicas    = 2

        selector {
            match_labels {
                app = "${var.backend_name}"
            }
        }

        template {
            metadata {
                namespace       = "${kubernetes_namespace.namespace.id}"
                labels {
                    app         = "${var.backend_name}"
                }
            }

            spec {
                container {
                    image               = "${var.backend_image}"
                    name                = "${var.backend_name}"
                    port {
                        container_port  = "${var.backend_container_port}"
                        name            = "http"
                    }
                    
                    image_pull_policy 	= "Always"
                    command             = ["/usr/bin/supervisord"]
                }
                container {
                    image               = "gcr.io/cloudsql-docker/gce-proxy:1.13"
                    name                = "cloudsql-proxy"
                    command             = ["/cloud_sql_proxy",
                                            "-instances=converge-postgres=tcp:5432",
                                            "-credential_file=/secrets/cloudsql/credentials.json",
                                            "-log_debug_stdout=true"]
                    security_context {
                        run_as_user                 = 2
                        allow_privilege_escalation  = "false"
                    }
                    volume_mount {
                        name            = "cloudsql-instance-credentials"
                        mount_path      = "/secrets/cloudsql"
                        read_only       = "true"
                    }
                }
                volume {
                    name                = "cloudsql-instance-credentials"
                    secret {
                        secret_name     = "cloudsql-instance-credentials"
                    }
                }
            }
        }
    }
}
