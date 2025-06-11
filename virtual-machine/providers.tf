terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

variable "subscription_id" {
  type = string
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}
