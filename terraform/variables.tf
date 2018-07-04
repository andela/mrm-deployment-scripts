variable "gcloud-region" {
  default = "europe-west1"
}

variable "gcloud-zone" {
  default = "europe-west1-b"
}

variable "gcloud-project" {
  default = "andela-learning"
}

variable "platform-name" {
  default = "mrm-sandbox"
}

variable "subnet-cidrs" {
  type = "map"

  default = {
    private-fe-be = "172.16.1.0/24"
    private-db-va = "172.16.13.0/24"
    public        = "172.16.200.0/24"
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
    elk-server      = "172.16.200.104"
    vault-server    = "172.16.13.101"
    postgres-server = "172.16.13.130"
    barman-server   = "172.16.13.201"
  }
}

variable "bucket" {
  default = "mrm-sandbox-tf-state"
}
