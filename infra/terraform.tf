terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.69"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.22"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}