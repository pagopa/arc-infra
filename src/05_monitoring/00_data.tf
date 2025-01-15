data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

#
# 🖥️ Monitor
#

data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace_name
  resource_group_name = local.monitor_resource_group_name
}

data "azurerm_monitor_action_group" "slack" {
  resource_group_name = local.monitor_resource_group_name
  name                = local.monitor_action_group_slack_name
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

#
# Container App Environment
#

data "azurerm_container_app_environment" "tools_cae" {
  name                = "${local.project_core}-tools-cae"
  resource_group_name = "${local.project_core}-tools-rg"
}

#
# Dns Private Zone
#

data "azurerm_private_dns_zone" "storage_account_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = local.vnet_core_resource_group_name
}

#
# Network
#

data "azurerm_subnet" "cae_subnet" {
  name                 = "${local.project_core}-cae-tools-snet"
  resource_group_name  = local.vnet_core_resource_group_name
  virtual_network_name = local.vnet_core_name
}

data "azurerm_public_ip" "appgateway_public_ip" {
  name                = "${local.project_core}-appgateway-pip"
  resource_group_name = local.vnet_core_resource_group_name
}
