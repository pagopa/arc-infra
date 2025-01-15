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
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.70.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=08bfcfae8b0ca536debf8452f0fe29405248dcfb"
}

