data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

#
# 🖥️ Monitor
#

data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace_name
  resource_group_name = local.monitor_resource_group_name
}

#
# 🔒 Secrets
#

data "azurerm_key_vault" "key_vault" {
  name                = "${local.project_core}-kv"
  resource_group_name = "${local.project_core}-sec-rg"
}

data "azurerm_key_vault_secret" "grafana_token" {
  name         = "grafana-token"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}
