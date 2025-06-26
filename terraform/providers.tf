terraform {
  required_version = ">= 1.6"

  backend "remote" {
    organization = "cacloudstudio"

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
