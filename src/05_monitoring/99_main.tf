terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.19"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.61.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=a88c6d99ec3871db7de57db4280422b02db3e4f0"
}
