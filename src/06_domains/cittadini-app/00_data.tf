data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

#
# 🖥️ Monitor
#

data "azurerm_resource_group" "monitor_rg" {
  name = local.monitor_resource_group_name
}

data "azurerm_application_insights" "application_insights" {
  name                = local.application_insights_name
  resource_group_name = local.monitor_resource_group_name
}

data "azurerm_monitor_action_group" "slack" {
  resource_group_name = local.monitor_resource_group_name
  name                = local.monitor_action_group_slack_name
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = local.monitor_resource_group_name
  name                = local.monitor_action_group_email_name
}

data "azurerm_key_vault_secret" "appinsights_connection_string" {
  name         = "appinsights-connection-string"
  key_vault_id = local.kv_domain_id
}

data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_name
  resource_group_name = local.monitor_resource_group_name
}

data "azurerm_redis_cache" "redis_common" {
  name                = "${local.project}-redis"
  resource_group_name = "${local.project}-redis-rg"
}