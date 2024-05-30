data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "vnet_rg" {
  name = "${local.project_core}-vnet-rg"
}
