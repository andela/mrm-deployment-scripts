variable "backend_name" {
    type        ="string"
}

variable "frontend_name" {
    type        ="string"
}

variable "credentials_file" {
    type        ="string"
}

variable "namespace" {
    type        ="string"
}

variable "backend_image" {
    type        ="string"
}

variable "frontend_image" {
    type        = "string"
}

variable "backend_container_port" {
    type        ="string"
}

variable "frontend_container_port" {
    type        ="string"
}

variable "ingress_template_file" {
    type        = "string"
}

variable "regional_static_ip" {
    type        = "string"
}

variable "frontend_domain_name" {
    type        = "string"
}

variable "backend_domain_name" {
    type        = "string"
}


variable "microservice_name" {
    type        = "string"
}

variable "microservice_image" {
    type        = "string"
}

variable "microservice_container_port" {
    type        = "string"
}

variable "microservice_domain_name" {
    type        = "string"
}

variable "microservice_namespace" {
    type        = "string"
}
