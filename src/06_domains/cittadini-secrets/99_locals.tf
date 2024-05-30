locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  #
  # 🔐 KV
  #
  key_vault_name    = "${local.project}-kv"
  key_vault_rg_name = "${local.project}-sec-rg"

  #
  # 💙 Azure
  #

  tenant_id       = data.azurerm_subscription.current.tenant_id
  subscription_id = data.azurerm_subscription.current.subscription_id
}