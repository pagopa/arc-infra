data "azurerm_key_vault_secret" "alert-slack-arc" {

  count = var.arc_alert_enabled ? 1 : 0

  name         = "alert-arc-notification-slack"
  key_vault_id = data.azurerm_key_vault.kv.id
}