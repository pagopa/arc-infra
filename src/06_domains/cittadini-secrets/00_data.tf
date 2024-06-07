data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azurerm_user_assigned_identity" "azdo_managed_identity" {
  name                = local.azdo_managed_identity_name
  resource_group_name = local.azdo_managed_identity_rg_name
}