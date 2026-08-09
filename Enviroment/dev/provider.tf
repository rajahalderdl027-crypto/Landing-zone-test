terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {

  subscription_id = "d8f7b6a1-332e-4afe-a4c9-8a60f1295d9c"

  features {}


}