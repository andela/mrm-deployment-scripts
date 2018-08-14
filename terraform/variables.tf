variable "gcloud_region" {
  type = "string"
  default = "europe-west1"
}

variable "gcloud_zone" {
  type = "string"
  default = "europe-west1-b"
}

variable "gcloud_project" {
  type = "string"
  default = "andela-learning"
}

variable "platform_name" {
  type = "string"
  default = "mrm-sandbox"
}

variable "vpc_cidr" {
  type = "string"
  default = "172.16.0.0/16"
}

variable "subnet_cidrs" {
  type = "map"
  default = {
	private-fe-be = "172.16.1.0/24", 
	private-db-va = "172.16.13.0/24", 
	public = "172.16.200.0/24"
	}
}

variable "startup_scripts" {
  type = "map"

  default = {
    nat-server      = "sudo sysctl -w net.ipv4.ip_forward=1; sudo iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE"
    vault-server    = "sudo su - packer -c '. /home/packer/startup-script.sh'"
    frontend-server = "sudo su - packer -c '. ~/startup-script.sh'"
    backend-server  = "sudo su - packer -c '. ~/startup-script.sh'"
  }
}

variable "static_ips" {
  type = "map"
  default = {
	elk-server = "172.16.200.104", 
	vault-server = "172.16.13.101", 
	postgres-server = "172.16.13.130", 
	barman-server = "172.16.13.201"
	}
}

variable "bucket" {
  type="string"
  default = "mrm-sandbox-tf-state"
}

variable "elk_server" {
  type = "string"
  default = "sandbox-elk-server"
}
