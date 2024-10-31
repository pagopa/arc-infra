#
# 🔐 KV
#

data "azurerm_key_vault" "key_vault" {
  name                = local.kv_domain_name
  resource_group_name = local.kv_domain_rg_name
}

data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault" "kv" {
  name                = "${local.product}-${var.domain}-kv"
  resource_group_name = "${local.product}-${var.domain}-sec-rg"
}

data "azurerm_key_vault_secret" "alert-slack-arc" {
  count        = var.alert_enabled ? 1 : 0
  name         = "alert-notification-slack"
  key_vault_id = data.azurerm_key_vault.kv.id
}