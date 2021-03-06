terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.11.0"
    }
  }
  
}

provider "azurerm" {
    features {}
}

locals {
    currentimage = var.imagebuild
}

terraform {
    backend "azurerm" {
      resource_group_name   = "tf_rg_blobstore"
      storage_account_name  = "tfstorageaccountseb"
      container_name        = "tfstate"
      key                   = "terraform.tfstate"
    }
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "uksouth"
}

resource "azurerm_container_group" "tfcg_test" {
    name                = var.apiname
    location            = azurerm_resource_group.tf_test.location
    resource_group_name = azurerm_resource_group.tf_test.name

    ip_address_type     = "Public"
    dns_name_label      = "sebcarterwa"
    os_type             = "Linux"

    container {
        name        = var.apiname
        image       = "${var.dockerID}/${var.apiname}:${local.currentimage}"
        cpu         = "1"
        memory      = "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
    }
}

// init
// plan
// apply
// destroy