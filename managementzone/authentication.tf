terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-eus-01"
    storage_account_name = "strtfstateeusbs001"
    container_name       = "tfstate-container"
    key                  = "dmz.tfstate"
  }

  required_providers {
    azurerm = {
      version = "=3.94.0"
    }
  }
}

########Configure the Azure Provider
provider "azurerm" {
  features {}
}