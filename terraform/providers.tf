terraform {
  required_version = ">= 1.6"

  cloud {
    organization = "CaCloudStudio"

    workspaces {
      name = "Infra"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.33.0"
    }
  }
}

provider "azurerm" {
  features {}
}
