terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-eus-01"
    storage_account_name = "strtfstateeusbs001"
    container_name       = "tfstate-container"
    key                  = "dlz.tfstate"
    use_oidc             = true
    tenant_id            = "16b3c013-d300-468d-ac64-7eda0820b6d3"
    client_id            = "128613ee-6ae3-4671-a358-9bd200c804e5"

  }

  required_providers {
    azurerm = {
      version = "=3.94.0"
    }
  }
}

#####Configure the Azure Provider
provider "azurerm" {
  features {}
}