terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "terraformk8stfstatefiles"
    container_name       = "k8stfstate"
    key                  = "k8sproject.tfstate"
  }
}

provider "azurerm" {
  features {}
  client_id       = var.client_id     # ENVIRONMENT VARIABLE
  client_secret   = var.client_secret # ENVIRONMENT VARIABLE
  subscription_id = "92ce78f8-6db3-4a60-9fa7-3e9d8179e33e"
  tenant_id       = "1c3cb17d-0059-4ba2-bd97-36f565114bbd"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group}_${var.environment}"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "terraform-k8s" {
  name                = "${var.cluster_name}_${var.environment}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  default_node_pool {
    name       = "agentpool"
    node_count = var.node_count
    vm_size    = "Standard_DS1_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = var.environment
  }
}