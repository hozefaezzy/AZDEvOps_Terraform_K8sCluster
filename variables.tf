variable "client_id" {}

variable "client_secret" {}

variable "ssh_public_key" {}

variable "environment" {
  default = "Dev"
}

variable "location" {
  default = "eastus"
}

variable "node_count" {
  default = 2
}



variable "dns_prefix" {
  default = "k8stest"
}

variable "cluster_name" {
  default = "k8stest"
}

variable "resource_group" {
  default = "kubernetes_rg"
}