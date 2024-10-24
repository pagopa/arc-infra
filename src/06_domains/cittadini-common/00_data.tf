data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

#
# 🌐 Networking
#

data "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_private_dns_zone" "privatelink_redis_azure_com" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = local.vnet_resource_group_name
}

# 🖥️ Monitor

data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace_name
  resource_group_name = local.monitor_resource_group_name
}

data "azurerm_application_insights" "application_insights" {
  name                = local.application_insights_name
  resource_group_name = local.monitor_resource_group_name
}

#
# 🔐 KV
#

data "azurerm_key_vault" "key_vault" {
  name                = local.kv_domain_name
  resource_group_name = local.kv_domain_rg_name
}

data "azurerm_key_vault" "key_vault_core" {
  name                = local.kv_core_name
  resource_group_name = local.kv_core_rg_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}
