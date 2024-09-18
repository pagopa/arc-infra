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

  tenant_id                     = data.azurerm_subscription.current.tenant_id
  subscription_id               = data.azurerm_subscription.current.subscription_id
  azdo_managed_identity_rg_name = "${local.project_core}-identity-rg"
  azdo_managed_identity_name    = upper("${var.env}-${var.prefix}-AZURE")
  azdo_iac_managed_identities = toset(["azdo-${var.env}-arc-iac-deploy", "azdo-${var.env}-arc-iac-plan"])
}