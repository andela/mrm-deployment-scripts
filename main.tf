module "gke" {
    source              = "./gke"
    project             = ""
    region              = ""
    zone                = "" 
    environment         = ""
    prefix              = ""
    credentials         = ""
    bucket              = ""
}

module "k8s" {
    source                  = "./k8s"
    credentials_file        = ""
    namespace               = ""
    backend_name            = ""
    backend_image           = ""
    backend_container_port  = ""
    frontend_name            = ""
    frontend_image           = ""
    frontend_container_port  = ""
}
