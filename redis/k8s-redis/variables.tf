variable "master_liveness_probe" {
  type        = "map"
  description = "Redis Master Liveness Probe configuration"

  default = {
    enabled               = true
    initial_delay_seconds = 30
    period_seconds        = 10
    timeout_seconds       = 5
    success_threshold     = 1
    failure_threshold     = 2
  }
}
variable "mount_path" {
  type = "string"
  description = "path to the location where redis will stores the rdb data"
}
variable "master_port" {
  type = "string"
  description = "defines the port onto which redis is running"
}
variable "storage_name" {
  type = "string"
  description = "name of the location where redis will stores the rdb data"
}
variable "storage_provisioner" {
  type = "string"
  description = "defines the name of the redis storage provisioner"
}
variable "storage_claim" {
  type = "string"
  description = "defines the name of the redis storage claim"
}
variable "service_name" {
  type = "string"
  description = "defines the name of the service that exposes the redis deployment"
}
variable "namespace" {
    type = "string"
    description = "defines the namespace containing the redis cluster"
}
variable "service_image" {
    type = "string"
    description = "defines the path to the redis image in gcr.io "
}
variable "config_name" {
  type = "string"
  description = "defines the name of the redis configuration"
}
variable "ingress_name" {
  type = "string"
  description = "defines the name of the ingress"
}
variable "config_template_file" {
    type = "string"
    description = "defines the file that contains the config map definition"
}
variable "ingress_file" {
    type = "string"
    description = "defines the file that contains the ingress"
}
variable "host_name" {
    type = "string"
    description = "name of the dns host with which to access redis"
}
variable "regional_static_ip" {
    type = "string"
    description = "defines the load balancer IP with which the redis service is accessed"
}
variable "ingress_controller_file" {
    type = "string"
    description = "defines the file that contains the ingress controller configuration"
}
