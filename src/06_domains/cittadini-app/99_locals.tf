locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}-${var.location_short}"

  # AKS
  aks_name = "${var.prefix}-${var.env_short}-${var.location_short}-${var.env}-aks"

  #
  # 💙 Azure
  #

  tenant_id       = data.azurerm_subscription.current.tenant_id
  subscription_id = data.azurerm_subscription.current.subscription_id
}