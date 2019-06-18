variable "project" {
    type        ="string"
    description = "defines the name of the project"
}
variable "name" {
    type = "string"
    description = "defines the name of the cluster"
}
variable "region" {
    type        = "string"
    description = "defines the region in which the cluster exists"
}
variable "zone" {
    type        = "string"
    description = "defines the cluster location"
}
variable "environment" {
    type        = "string"
    description = "defines the environment of the cluster"
}
variable "prefix" {
    type        = "string"
    description = "defines the cluster bucket prefix"
}
variable "credentials" {
    type        = "string"
    description = "defines the account credentials used to access the google console"
}
variable "bucket" {
    type        = "string"
    description = "defines the bucket that stores the cluster state file"
}
variable "username" {
    type        = "string"
    description = "defines the username of the cluster administrator"
}
variable "password" {
    type        = "string"
    description = "defines the password used to authorize access to the cluster"
}
