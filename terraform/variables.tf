variable "gcloud-region" {
  default = "europe-west1"
}

variable "gcloud-zone" {
  default = "europe-west1-b"
}

variable "gcloud-project" {
  default = "learning-map-app"
}

variable "platform-name" {
  default = "mrm"
}

variable "subnet-cidrs" {
  type = "map"

  default = {
    private-fe-be = "192.168.1.0/24"
    private-db-va = "192.168.13.0/24"
    public        = "192.168.200.0/24"
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
    vault-server    = "192.168.13.101"
    postgres-server = "192.168.13.130"
    barman-server   = "192.168.13.201"
  }
}

variable "bucket" {
  default = "mrm-tf-state"
}
