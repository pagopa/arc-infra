terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
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

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v1.10.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=d1ebe17dff7d50a5ac9851f9dc9f8c379e1bced0"
}
