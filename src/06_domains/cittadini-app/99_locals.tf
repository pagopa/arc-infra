locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}-${var.location_short}"

  # AKS
  aks_name                = "${local.product}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.env}-aks-rg"

  #
  # 💙 Azure
  #
  tenant_id       = data.azurerm_subscription.current.tenant_id
  subscription_id = data.azurerm_subscription.current.subscription_id

  #
  # 🔐 KV
  #
  kv_domain_id      = data.azurerm_key_vault.key_vault.id
  kv_domain_name    = "${local.project}-kv"
  kv_domain_rg_name = "${local.project}-sec-rg"
}