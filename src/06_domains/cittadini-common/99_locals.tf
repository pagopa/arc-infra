locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  # AKS
  aks_name                = "${local.product}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.location_short}-${var.env}-aks-rg"
  aks_api_url             = data.azurerm_kubernetes_cluster.aks.private_fqdn

  #
  # 🌐 Networking
  #

  vnet_name                = "${local.project_core}-vnet"
  vnet_resource_group_name = "${local.project_core}-vnet-rg"
  vnet_id                  = data.azurerm_virtual_network.vnet.id

  #
  # 🖥️ Monitor
  #
  application_insights_name    = "${local.project_core}-appinsights"
  monitor_resource_group_name  = "${local.project_core}-monitor-rg"
  log_analytics_workspace_name = "${local.project_core}-law"
  log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id

  #
  # 🔐 KV
  #
  kv_domain_id      = data.azurerm_key_vault.key_vault.id
  kv_domain_name    = "${local.product}-${var.location_short}-${var.domain}-kv"
  kv_domain_rg_name = "${local.project}-sec-rg"

  kv_core_name    = "${local.project_core}-kv"
  kv_core_rg_name = "${local.project_core}-sec-rg"
  kv_core_id      = data.azurerm_key_vault.key_vault_core.id

  #
  # 💙 Azure
  #

  tenant_id       = data.azurerm_subscription.current.tenant_id
  subscription_id = data.azurerm_subscription.current.subscription_id

}